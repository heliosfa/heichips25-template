`timescale 1ns / 1ps
module heichips25_template(
  input logic clk, rst_n, ena,

  // Standard I/O pins to the fabric
  input logic [7:0] ui_in,
  input logic [7:0] uio_in,
  output logic [7:0] uo_out,
  output logic [7:0] uio_out,
  output logic [7:0] uio_oe,

  // HDMI dedicated outputs
  output logic tmds_b, tmds_g, tmds_r, tmds_clk
);

  logic reset;
  logic clk_video;
  logic clk_tmds;

  logic display_enable;
  logic hsync, vsync;

  logic [7:0] red, green, blue;
  logic [9:0] red_tmds_par, green_tmds_par, blue_tmds_par;

  assign reset = ~rst_n;    // We want active high reset for things...

  assign tmds_clk = clk_tmds;   // TMDS clock output
  //assign clk_video = clk_25;    // Needed for FPGA to work...
  //assign clk_video = clk_tmds;    // What we want to use on FPGA

  // Unused Pins
  assign uio_out[7:5] = 0;
  assign uio_oe = '0;

  clock_5_div clockdiv (
    .clk(clk),
    .reset(reset),
    .clkdiv(clk_video)
  );

  video videogen (
    .clk(clk_video),
    .reset(reset),
    .animation_select(ui_in[1:0]),
    .r(red),
    .g(green),
    .b(blue),
    .hsync(hsync),
    .vsync(vsync),
    .de(display_enable),

    .pixel_in(ui_in[7:4]),
    .bank(uio_out[1]),
    .addr({uio_out[0],uo_out}),
    .pix_sel(uio_out[4:2])
  );

  tmds_encoder tmds_red (
    .clk(clk_video),
    .reset(reset),
    .disp_enable(display_enable),
    .hsync('0),
    .vsync('0),
    .color_data(red),
    .tmds_encoded(red_tmds_par)
  );
  
  tmds_encoder tmds_green (
    .clk(clk_video),
    .reset(reset),
    .disp_enable(display_enable),
    .hsync('0),
    .vsync('0),
    .color_data(green),
    .tmds_encoded(green_tmds_par)
  );
  
  tmds_encoder tmds_blue (
    .clk(clk_video),
    .reset(reset),
    .disp_enable(display_enable),
    .hsync(hsync),
    .vsync(vsync),
    .color_data(blue),
    .tmds_encoded(blue_tmds_par)
  );
  
  tmds_serializer serialize (
    .serclk(clk),
    .rst(reset),
    .tmds_parallel_r(red_tmds_par),
    .tmds_parallel_g(green_tmds_par),
    .tmds_parallel_b(blue_tmds_par),
    .tmds_serial_r(tmds_r),
    .tmds_serial_g(tmds_g),
    .tmds_serial_b(tmds_b),
    .tmds_serial_c(clk_tmds)
  );


endmodule
