module pixel_feeder(
  input logic clk_25, rst_n,

  output logic [3:0] pixel_out,     // Output pixel. Feb from 64-pixel buffer
  input logic [3:0] pixel_in,       // Input pixel, from memory

  // Address pins
  output logic [8:0] addr,          // Memory address we want
  output logic [2:0] pix_sel,       // Pixel from memory that we want
  
  input logic disp_active, line_end, frame_end,    // Video signals for sync

  output logic mem_read,            // Indicates if we are actively using memory
  output logic mem_row              // indicates if we are in the row where we read memory
);

  logic [3:0] row [5:0];              // 64-pixel buffer to hold an entire row
  logic [3:0] h_counter, v_counter;   // Counters for tracking the /10 for H and V.
  logic [5:0] h_pix, v_pix;           // Local pixel counts
  
  // Pixel Fetcher state machine
  // If we are at v_counter 9, we want to read the pixel for the next row into the buffer when h_counter gets to 9
  // We can get away with one state for reading memory as memory is running at 126 MHz while this is running at 25 MHz,
  // So memory will be ready on the negative clock edge...
  enum {s_idle = 0, s_mem_read = 1, s_blank} state, next_state;
  
  always_comb begin
    pixel_out = row[h_pix];            // Grab the specific pixel for the row
    if (state == s_mem_read) mem_read = 1;                  // Indicate our state
    else mem_read = 0;
    if ((disp_active && v_counter == 9)|| state == s_mem_read) mem_row = 1;   // Indicate when we are on a memory reading row
    else mem_row = 0;
  end
  
  // Next state logic
  always_comb begin
    next_state = s_idle;
    case (state)
      s_mem_read :  next_state = s_idle;
      s_blank :     begin
                      if (disp_active) next_state = s_idle;
                      else next_state = s_blank;
                    end
      default :     begin
                      if((v_counter == 9) && (h_counter == 9) && (disp_active||line_end)) next_state = s_mem_read;
                      else if(!disp_active) next_state = s_blank;
                      else next_state = s_idle;
                    end
    endcase
  end

  // Address decode output logic
  always_comb begin
    if (state == s_mem_read) begin
      if (v_pix == 48) begin // Edge case if we are on the last line
        if (h_pix == 63 && v_counter == 0) {addr,pix_sel} = {6'b000000,6'b000000};
        else {addr,pix_sel} = {6'b000000,h_pix}-1;
      end else begin 
        if (h_pix == 63 && v_counter == 0) {addr,pix_sel} = {(v_pix),6'b111111};   //Edge case to grab the last pixel
        else {addr,pix_sel} = {(v_pix+1),h_pix}-1;                              // Set the memory address to get the nextrow
      end
    end else  {addr,pix_sel} = '0;              // Clear the memory address
  end

  always_ff @(posedge clk_25) begin
    if(!rst_n) state <= s_blank;
    else state <= next_state;
  end

  always_ff @(negedge clk_25) begin
    if(state == s_mem_read) begin
      // Save the pixel from the memory interface.
      if(h_pix == 63 && v_counter == 0) row[63] <= pixel_in;    // Edge case for  the last pixel
      else row[h_pix-1] <= pixel_in;
    end
  end
  

  // The counters that make it all work:  
  // Horizontal pixel counter. Increments every 10th pixel
  always_ff @(posedge clk_25 or negedge rst_n) begin
if (state == s_blank || !rst_n) begin 
        h_counter <= 0;                // Hold at 0 during display inactive to resync.
        h_pix <= 0;                    // Hold horizontal pixel count at 0 during display inactive to resync.
    end
    else if (disp_active) begin              // Only increment if the display is active
      if (h_counter < 9) h_counter <= h_counter + 1;
      else begin
        h_counter <= 0;                 
        h_pix <= h_pix + 1;             // Increment the horizontal pixel co-ordinate.
      end
    end
  end
  
  // Vertical pixel count, incremented on line_end. Async reset on frame_end
  always_ff @(posedge line_end or posedge frame_end) begin   
    if (frame_end || !rst_n) begin
      v_counter <= 9;     // resync counter on frame end
      v_pix <= 0;
    end
    else if (state != s_blank) begin
      if (v_counter < 9) v_counter <= v_counter + 1;
      else begin 
        v_counter <= 0;
        if (v_pix < 47) v_pix <= v_pix +1;              // Increment the vertical pixel co-ordinate
        else v_pix <= 0;
      end
    end
  end    
  
endmodule
