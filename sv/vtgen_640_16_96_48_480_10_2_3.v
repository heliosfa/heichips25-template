`timescale 1ns / 1ps
module vtgen_640_16_96_48_480_10_2_33
  (input  clk,
   input  reset,
   output disp_active,
   output [9:0] disp_x,
   output [9:0] disp_y,
   output frame_end,
   output line_end,
   output hdmi_vsync,
   output hdmi_hsync,
   output hdmi_de);
  wire [9:0] disp_x_reg;
  wire [9:0] disp_y_reg;
  wire n478;
  wire n480;
  wire [9:0] n482;
  wire [9:0] n484;
  wire [9:0] n486;
  wire [9:0] n488;
  wire [9:0] n489;
  wire [9:0] n491;
  wire [9:0] n493;
  wire n499;
  wire n501;
  wire n502;
  wire n505;
  wire n508;
  wire n510;
  wire n511;
  wire n514;
  wire n517;
  wire n519;
  wire n520;
  wire n523;
  wire n526;
  wire n528;
  wire n529;
  wire n532;
  wire n535;
  wire n537;
  wire n540;
  wire n543;
  wire n545;
  wire n548;
  reg [9:0] n551;
  reg [9:0] n552;
  assign disp_active = n532; //(module output)
  assign disp_x = disp_x_reg; //(module output)
  assign disp_y = disp_y_reg; //(module output)
  assign frame_end = n545; //(module output)
  assign line_end = n548; //(module output)
  assign hdmi_vsync = n514; //(module output)
  assign hdmi_hsync = n505; //(module output)
  assign hdmi_de = n523; //(module output)
  /* vtgen.vhdl:105:12  */
  assign disp_x_reg = n551; // (signal)
  /* vtgen.vhdl:107:12  */
  assign disp_y_reg = n552; // (signal)
  /* vtgen.vhdl:121:32  */
  assign n478 = disp_x_reg == 10'b1100011111;
  /* vtgen.vhdl:123:36  */
  assign n480 = disp_y_reg == 10'b1000001011;
  /* vtgen.vhdl:126:50  */
  assign n482 = disp_y_reg + 10'b0000000001;
  /* vtgen.vhdl:123:21  */
  assign n484 = n480 ? 10'b0000000000 : n482;
  /* vtgen.vhdl:129:46  */
  assign n486 = disp_x_reg + 10'b0000000001;
  /* vtgen.vhdl:121:17  */
  assign n488 = n478 ? 10'b0000000000 : n486;
  /* vtgen.vhdl:121:17  */
  assign n489 = n478 ? n484 : disp_y_reg;
  /* vtgen.vhdl:117:13  */
  assign n491 = reset ? 10'b0000000000 : n488;
  /* vtgen.vhdl:117:13  */
  assign n493 = reset ? 10'b0000000000 : n489;
  /* vtgen.vhdl:145:24  */
  assign n499 = $unsigned(disp_x_reg) >= $unsigned(10'b1010001111);
  /* vtgen.vhdl:145:57  */
  assign n501 = $unsigned(disp_x_reg) < $unsigned(10'b1011101111);
  /* vtgen.vhdl:145:41  */
  assign n502 = n501 & n499;
  /* vtgen.vhdl:145:9  */
  assign n505 = n502 ? 1'b0 : 1'b1;
  /* vtgen.vhdl:149:24  */
  assign n508 = $unsigned(disp_y_reg) >= $unsigned(10'b0111101001);
  /* vtgen.vhdl:149:57  */
  assign n510 = $unsigned(disp_y_reg) < $unsigned(10'b0111101011);
  /* vtgen.vhdl:149:41  */
  assign n511 = n510 & n508;
  /* vtgen.vhdl:149:9  */
  assign n514 = n511 ? 1'b0 : 1'b1;
  /* vtgen.vhdl:153:24  */
  assign n517 = $unsigned(disp_x_reg) <= $unsigned(10'b1001111111);
  /* vtgen.vhdl:153:58  */
  assign n519 = $unsigned(disp_y_reg) <= $unsigned(10'b0111011111);
  /* vtgen.vhdl:153:42  */
  assign n520 = n519 & n517;
  /* vtgen.vhdl:153:9  */
  assign n523 = n520 ? 1'b1 : 1'b0;
  /* vtgen.vhdl:157:24  */
  assign n526 = $unsigned(disp_x_reg) > $unsigned(10'b1001111111);
  /* vtgen.vhdl:157:56  */
  assign n528 = $unsigned(disp_y_reg) > $unsigned(10'b0111011111);
  /* vtgen.vhdl:157:41  */
  assign n529 = n526 | n528;
  /* vtgen.vhdl:157:9  */
  assign n532 = n529 ? 1'b0 : 1'b1;
  /* vtgen.vhdl:161:23  */
  assign n535 = disp_x_reg == 10'b1010000000;
  /* vtgen.vhdl:162:27  */
  assign n537 = disp_y_reg == 10'b0111100000;
  /* vtgen.vhdl:162:13  */
  assign n540 = n537 ? 1'b1 : 1'b0;
  /* vtgen.vhdl:162:13  */
  assign n543 = n537 ? 1'b0 : 1'b1;
  /* vtgen.vhdl:161:9  */
  assign n545 = n535 ? n540 : 1'b0;
  /* vtgen.vhdl:161:9  */
  assign n548 = n535 ? n543 : 1'b0;
  /* vtgen.vhdl:116:9  */
  always @(posedge clk)
    n551 <= n491;
  /* vtgen.vhdl:116:9  */
  always @(posedge clk)
    n552 <= n493;
endmodule
