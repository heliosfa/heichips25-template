`timescale 1ns / 1ps
module pix_streacher
  (input  clk_25mhz,
   input  rst,
   input  line_end,
   input  frame_end,
   input  de_enable,
   input  [3:0] data_in,
   output [3:0] data_out);
  wire state;
  wire next_state;
  reg [3:0] de_count;
  reg [3:0] next_count;
  reg [3:0] data_reg;
  reg [3:0] next_data;
  wire n706;
  wire [3:0] n708;
  wire [3:0] n710;
  wire [3:0] n718;
  wire n720;
  wire [3:0] n721;
  wire n723;
  wire n725;
  wire [3:0] n727;
  wire n729;
  wire [3:0] n731;
  wire [3:0] n732;
  wire n733;
  wire [3:0] n734;
  wire n735;
  wire n737;
  wire [1:0] n738;
  reg n740;
  reg [3:0] n742;
  reg [3:0] n744;
  reg n746;
  reg [3:0] n747;
  reg [3:0] n748;
  assign data_out = data_reg; //(module output)
  /* pix_Streacher.vhdl:20:12  */
  assign state = n746; // (signal)
  /* pix_Streacher.vhdl:20:19  */
  assign next_state = n740; // (signal)
  /* pix_Streacher.vhdl:23:12  */
  always @*
    de_count = n747; // (isignal)
  initial
    de_count = 4'b0000;
  /* pix_Streacher.vhdl:23:22  */
  always @*
    next_count = n742; // (isignal)
  initial
    next_count = 4'b0000;
  /* pix_Streacher.vhdl:26:12  */
  always @*
    data_reg = n748; // (isignal)
  initial
    data_reg = 4'b0000;
  /* pix_Streacher.vhdl:26:22  */
  always @*
    next_data = n744; // (isignal)
  initial
    next_data = 4'b0000;
  /* pix_Streacher.vhdl:34:13  */
  assign n706 = rst ? 1'b0 : next_state;
  /* pix_Streacher.vhdl:34:13  */
  assign n708 = rst ? 4'b0000 : next_count;
  /* pix_Streacher.vhdl:34:13  */
  assign n710 = rst ? 4'b0000 : next_data;
  /* pix_Streacher.vhdl:60:44  */
  assign n718 = de_count + 4'b0001;
  /* pix_Streacher.vhdl:59:17  */
  assign n720 = de_enable ? 1'b1 : state;
  /* pix_Streacher.vhdl:59:17  */
  assign n721 = de_enable ? n718 : de_count;
  /* pix_Streacher.vhdl:58:13  */
  assign n723 = state == 1'b0;
  /* pix_Streacher.vhdl:67:33  */
  assign n725 = de_count == 4'b1001;
  /* pix_Streacher.vhdl:72:48  */
  assign n727 = de_count + 4'b0001;
  /* pix_Streacher.vhdl:66:17  */
  assign n729 = n733 ? 1'b0 : state;
  /* pix_Streacher.vhdl:67:21  */
  assign n731 = n725 ? 4'b0000 : n727;
  /* pix_Streacher.vhdl:66:17  */
  assign n732 = n735 ? data_in : data_reg;
  /* pix_Streacher.vhdl:66:17  */
  assign n733 = n725 & de_enable;
  /* pix_Streacher.vhdl:66:17  */
  assign n734 = de_enable ? n731 : de_count;
  /* pix_Streacher.vhdl:66:17  */
  assign n735 = n725 & de_enable;
  /* pix_Streacher.vhdl:65:13  */
  assign n737 = state == 1'b1;
  assign n738 = {n737, n723};
  /* pix_Streacher.vhdl:56:9  */
  always @*
    case (n738)
      2'b10: n740 = n729;
      2'b01: n740 = n720;
      default: n740 = 1'bX;
    endcase
  /* pix_Streacher.vhdl:56:9  */
  always @*
    case (n738)
      2'b10: n742 = n734;
      2'b01: n742 = n721;
      default: n742 = 4'bX;
    endcase
  /* pix_Streacher.vhdl:56:9  */
  always @*
    case (n738)
      2'b10: n744 = n732;
      2'b01: n744 = data_reg;
      default: n744 = 4'bX;
    endcase
  /* pix_Streacher.vhdl:33:9  */
  always @(posedge clk_25mhz)
    n746 <= n706;
  /* pix_Streacher.vhdl:33:9  */
  always @(posedge clk_25mhz)
    n747 <= n708;
  initial
    n747 = 4'b0000;
  /* pix_Streacher.vhdl:33:9  */
  always @(posedge clk_25mhz)
    n748 <= n710;
  initial
    n748 = 4'b0000;
endmodule