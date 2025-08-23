`timescale 1ns / 1ps
module video (
  input logic clk, reset,
  input  logic [1:0] animation_select,
  output logic [7:0] r, g, b,
  output logic hsync, vsync, de,

  input logic [3:0] pixel_in,

  // Memory addresses
  output logic bank,
  output logic [8:0] addr,
  output logic [2:0] pix_sel
);

  logic [9:0] video_x, video_y;   // Video co-ordinates

  logic draw_active;
  logic line_end_reached;
  logic frame_end_reached;

  logic [7:0] r_next, g_next, b_next;  // Next pixel values
  logic [7:0] r_reg, g_reg, b_reg;     // Current pixel values

  logic de_next, hsync_next, vsync_next;
  logic de_reg, hsync_reg, vsync_reg;

  logic [7:0] shader_red, shader_green, shader_blue;
  logic [7:0] lut_red, lut_green, lut_blue;

  // Output logic
  always_comb begin
    r = r_reg;
    g = g_reg;
    b = b_reg;
    de = de_reg;
    hsync = hsync_reg;
    vsync = vsync_reg;
  end
  
  // Animation mux
  always_comb begin
    case (animation_select[0])
      1'b1    :   begin
        r_next = shader_red;
        g_next = shader_green;
        b_next = shader_blue;
      end
      default :   begin
        r_next = lut_red;
        g_next = lut_green;
        b_next = lut_blue;
      end
    endcase
  end

  // State machine registers...
  always_ff @(posedge clk) begin
    if (reset) begin
      r_reg <= '0;
      g_reg <= '0;
      b_reg <= '0;
      de_reg <= '0;
      hsync_reg <= '0;
      vsync_reg <= '0;
    end else begin
      r_reg <= r_next;
      g_reg <= g_next;
      b_reg <= b_next;
      de_reg <= de_next;
      hsync_reg <= hsync_next;
      vsync_reg <= vsync_next;
    end
  end

  // Video timing generator
  vtgen_640_16_96_48_480_10_2_33 video_timing_generator (
    .clk(clk),
    .reset(reset),
    .disp_active(draw_active),
    .disp_x(video_x),
    .disp_y(video_y),
    .frame_end(frame_end_reached),
    .line_end(line_end_reached),
    .hdmi_vsync(vsync_next),
    .hdmi_hsync(hsync_next),
    .hdmi_de(de_next)
  );

  // The fancy test shader
  shader fancy_shader (
    .clk(clk),
    .reset(reset),
    .video_x(video_x),
    .video_y(video_y),
    .disp_active(draw_active),
    .frame_end(frame_end_reached),
    .line_end(line_end_reached),
    .r(shader_red),
    .g(shader_green),
    .b(shader_blue)
  );

  // The tests involving the Color LUT
  gol_test test_lut_thingy (
    .clk(clk),
    .reset(reset),
    .line_end(line_end_reached),
    .frame_end(frame_end_reached),
    .display_enable(draw_active),
    .r(lut_red),
    .g(lut_green),
    .b(lut_blue),

    .pixel_in(pixel_in),
    .bank(bank),
    .addr(addr),
    .pix_sel(pix_sel),

    .source(animation_select[1])
  );

endmodule
