`timescale 1ns / 1ps

module gol_test (
  input logic clk,
  input logic reset,
  input logic line_end,
  input logic frame_end,
  input logic display_enable,
  output logic[7:0] r, g, b,

  input logic [3:0] pixel_in,

  // Memory addresses
  output logic bank,
  output logic [8:0] addr,
  output logic [2:0] pix_sel,

  input logic source
);
  logic rst_n;

  logic [7:0] red_channel;
  logic [7:0] green_channel;
  logic [7:0] blue_channel;
  logic [3:0] data_out;
  logic [3:0] gol_counter_reg, pf_out, col_to_lut;

  logic mem_read, mem_row;

  assign rst_n = ~reset;
  assign bank = 0;

  assign r = red_channel; // (module output)
  assign g = green_channel; // (module output)
  assign b = blue_channel; // (module output)

  always_comb begin
    col_to_lut = gol_counter_reg;
    if (source) col_to_lut = pf_out; //pixel_in; // 4'b0111;
  end
  //assign col_to_lut = gol_counter_reg;

  /* gol_test.vhdl:37:5  */
  color_lut color_lut_inst (
      .in_color(col_to_lut),
      .red_channel(red_channel),
      .green_channel(green_channel),
      .blue_channel(blue_channel)
  );

  // gol_counter
  always_ff @(posedge clk) begin 
    if(reset) gol_counter_reg <= 0;
    else gol_counter_reg = gol_counter_reg + 1;
  end

  
  pixel_feeder (
    .clk_25(clk),
    .rst_n(rst_n),
    .pixel_out(pf_out),
    .pixel_in(pixel_in),
    .mem_read(mem_read),
    .mem_row(mem_row),
    .addr(addr),
    .pix_sel(pix_sel),
    .disp_active(display_enable),
    .line_end(line_end),
    .frame_end(frame_end)
  );

endmodule
