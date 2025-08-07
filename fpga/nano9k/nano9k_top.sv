module nano9k_top
  (input  clk,
   input  rst_n,
   output [5:0] leds);
  reg [5:0] counter_reg;
  reg [22:0] clkdiv_reg;
  wire n4_o;
  wire [22:0] n7_o;
  wire n9_o;
  wire [5:0] n11_o;
  wire [22:0] n14_o;
  wire [5:0] n22_o;
  reg [5:0] n23_q;
  reg [22:0] n24_q;
  assign leds = counter_reg;
  /* tang9k_top.vhdl:22:12  */
  always @*
    counter_reg = n23_q; // (isignal)
  initial
    counter_reg = 6'b000000;
  /* tang9k_top.vhdl:23:12  */
  always @*
    clkdiv_reg = n24_q; // (isignal)
  initial
    clkdiv_reg = 23'b00000000000000000000000;
  /* tang9k_top.vhdl:32:18  */
  assign n4_o = ~rst_n;
  /* tang9k_top.vhdl:38:38  */
  assign n7_o = clkdiv_reg + 23'b00000000000000000000001;
  /* tang9k_top.vhdl:41:27  */
  assign n9_o = clkdiv_reg == 23'b11001101111111100110000;
  /* tang9k_top.vhdl:44:44  */
  assign n11_o = counter_reg + 6'b000001;
  /* tang9k_top.vhdl:41:13  */
  assign n14_o = n9_o ? 23'b00000000000000000000000 : n7_o;
  /* tang9k_top.vhdl:36:9  */
  assign n22_o = n9_o ? n11_o : counter_reg;
  /* tang9k_top.vhdl:36:9  */
  always @(posedge clk or posedge n4_o)
    if (n4_o)
      n23_q <= 6'b000000;
    else
      n23_q <= n22_o;
  /* tang9k_top.vhdl:36:9  */
  always @(posedge clk or posedge n4_o)
    if (n4_o)
      n24_q <= 23'b00000000000000000000000;
    else
      n24_q <= n14_o;
endmodule

