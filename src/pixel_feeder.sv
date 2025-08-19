module pixel_feeder(
  input logic clk, clk_25, rst_n,

  output logic [3:0] pixelOut,
  input logic [3:0] pixelIn,

  // Address pins
  output logic bank,
  output logic [8:0] addr,
  output logic [2:0] pixSel

);

  logic [3:0] row [5:0];              // 64-pixel buffer to hold an entire row
  logic [3:0] h_counter, v_counter;   // Counters for tracking the /10 for H and V.
  logic [5:0] h_pix, v_pix;           // Local pixel counts
  
  // Grab the specific pixel for the row
  always_comb begin
    pixelOut = row[h_pix];
  end
  

  // Pixel Fetcher state machine
  // If we are at v_counter 9, we want to read the pixel for the next row into the buffer when h_counter gets to 9
  

  
  // Horizontal pixel counter. Increments every 10th pixel
  always_ff @(posedge clk_25) begin   
    if (!disp_active) begin 
        h_counter <= 9;                // Hold at 9 during display inactive to resync.
        h_pix <= 63;                    // Hold horizontal pixel count at 63 during display inactive to resync.
    end
    if (disp_active) begin              // Only increment if the display is active
      if (h_counter < 9) h_counter <= h_counter + 1;
      else begin
        h_counter <= 0;                 
        h_pix <= h_pix + 1;             // Increment the horizontal pixel co-ordinate.
      end
    end
  end
  
  // Vertical pixel count, incremented on line_end. Async reset on frame_end
  always_ff @(posedge line_end or posedge frame_end) begin   
    if (frame_end) begin
      v_counter <= 9;     // resync counter on frame end
      else v_pix <= 47;
    end
    else if (v_counter < 9) v_counter <= v_counter + 1;
    else begin 
      v_counter <= 0;
      if (v_pix < 47) v_pix <= v_pix +1;              // Increment the vertical pixel co-ordinate
      else v_pix <= 0;
    end
  end    
  
endmodule