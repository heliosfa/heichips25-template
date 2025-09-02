module shader(
  input  clk,
  input  reset,
  input  [9:0] video_x,
  input  [9:0] video_y,
  input  disp_active,
  input  frame_end,
  input  line_end,
  output [7:0] r,
  output [7:0] g,
  output [7:0] b
);

  logic [9:0] shader_counter_reg, shader_counter_next;
  logic [7:0] temp_r, temp_g, temp_b;
  logic [9:0] sum_x, sum_y;

  // Output logic
  assign r = temp_r[7:0];
  assign g = temp_g[7:0];
  assign b = temp_b[7:0];

  
  always_ff @(posedge clk) begin
    if(~disp_active) begin    // No functional change but clears a warning and saves a little power.
      if (reset) shader_counter_reg <= 10'd0;
      else shader_counter_reg <= shader_counter_next;
    end
  end

  // "shader magic"
  always_comb begin
    temp_r = 8'd0;
    temp_g = 8'd0;
    temp_b = 8'd0;
    shader_counter_next = shader_counter_reg;

    // Increment once per frame
    if (frame_end) begin
      shader_counter_next = shader_counter_reg + (10'd1 | {9'd0,line_end}); // 10-bit wrap
    end

    // Common intermediates (10-bit wrap on adds)
    sum_x    = video_x + shader_counter_reg;
    sum_y    = video_y + shader_counter_reg;

    // Blue channel:
    // if ((((sum_y ^ sum_x) % 7) | ((sum_y ^ sum_x) % 9)) > 1) then all ones
    if ((((sum_y ^ sum_x) % 10'd7) | ((sum_y ^ sum_x) % 10'd9)) > 10'd1)
      temp_b = '1;

    // Green channel:
    // if ((((sum_y) ^ sum_x) % 7) | (((sum_y+1) ^ sum_x) % 9)) > 1 then all ones
    if ((((sum_y ^ sum_x) % 10'd7) | (((sum_y + 10'd1) ^ sum_x) % 10'd9)) > 10'd1)
      temp_g = '1;

    // Red channel (inverted outcome vs G/B):
    // if ((((sum_y+1) ^ (sum_x+1)) % 7) | (((sum_y+2) ^ (sum_x+1)) % 9)) > 1 then zeros else ones
    if (((((sum_y + 10'd1) ^ (sum_x + 10'd1)) % 10'd7) | (((sum_y + 10'd2) ^ (sum_x + 10'd1)) % 10'd9)) > 10'd1)
      temp_r = '0;
    else
      temp_r = '1;
  end
endmodule

