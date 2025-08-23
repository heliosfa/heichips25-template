module clock_5_div
  (input  clk,
   input  reset,
   output clkdiv);
  wire partitial_clock_a;
  wire partitial_clock_b;
  wire [3:0] counter_a_reg;
  wire [3:0] counter_b_reg;
  wire [3:0] n4;
  wire n6;
  wire n8;
  wire n11;
  wire n13;
  wire [3:0] n15;
  wire [3:0] n26;
  wire n28;
  wire n30;
  wire n33;
  wire n35;
  wire [3:0] n37;
  wire n45;
  reg n46;
  reg n47;
  reg [3:0] n48;
  reg [3:0] n49;
  assign clkdiv = n45; //(module output)
  /* heichips25-template/src/clock_5_div.vhdl:16:12  */
  assign partitial_clock_a = n46; // (signal)
  /* heichips25-template/src/clock_5_div.vhdl:16:31  */
  assign partitial_clock_b = n47; // (signal)
  /* heichips25-template/src/clock_5_div.vhdl:17:12  */
  assign counter_a_reg = n48; // (signal)
  /* heichips25-template/src/clock_5_div.vhdl:17:27  */
  assign counter_b_reg = n49; // (signal)
  /* heichips25-template/src/clock_5_div.vhdl:30:44  */
  assign n4 = counter_a_reg + 4'b0001;
  /* heichips25-template/src/clock_5_div.vhdl:32:30  */
  assign n6 = counter_a_reg == 4'b0101;
  /* heichips25-template/src/clock_5_div.vhdl:36:33  */
  assign n8 = $unsigned(counter_a_reg) >= $unsigned(4'b0010);
  /* heichips25-template/src/clock_5_div.vhdl:36:13  */
  assign n11 = n8 ? 1'b0 : 1'b1;
  /* heichips25-template/src/clock_5_div.vhdl:32:13  */
  assign n13 = n6 ? 1'b1 : n11;
  /* heichips25-template/src/clock_5_div.vhdl:32:13  */
  assign n15 = n6 ? 4'b0001 : n4;
  /* heichips25-template/src/clock_5_div.vhdl:54:44  */
  assign n26 = counter_b_reg + 4'b0001;
  /* heichips25-template/src/clock_5_div.vhdl:56:30  */
  assign n28 = counter_b_reg == 4'b0101;
  /* heichips25-template/src/clock_5_div.vhdl:60:33  */
  assign n30 = $unsigned(counter_b_reg) >= $unsigned(4'b0010);
  /* heichips25-template/src/clock_5_div.vhdl:60:13  */
  assign n33 = n30 ? 1'b0 : 1'b1;
  /* heichips25-template/src/clock_5_div.vhdl:56:13  */
  assign n35 = n28 ? 1'b1 : n33;
  /* heichips25-template/src/clock_5_div.vhdl:56:13  */
  assign n37 = n28 ? 4'b0001 : n26;
  /* heichips25-template/src/clock_5_div.vhdl:70:33  */
  assign n45 = partitial_clock_a | partitial_clock_b;
  /* heichips25-template/src/clock_5_div.vhdl:28:9  */
  always @(posedge clk or posedge reset)
    if (reset)
      n46 <= 1'b0;
    else
      n46 <= n13;
  /* heichips25-template/src/clock_5_div.vhdl:52:9  */
  always @(negedge clk or posedge reset)
    if (reset)
      n47 <= 1'b0;
    else
      n47 <= n35;
  /* heichips25-template/src/clock_5_div.vhdl:28:9  */
  always @(posedge clk or posedge reset)
    if (reset)
      n48 <= 4'b0000;
    else
      n48 <= n15;
  /* heichips25-template/src/clock_5_div.vhdl:52:9  */
  always @(negedge clk or posedge reset)
    if (reset)
      n49 <= 4'b0000;
    else
      n49 <= n37;
endmodule

