`timescale 1ns / 1ps
module shader
  (input  clk,
   input  reset,
   input  [9:0] video_x,
   input  [9:0] video_y,
   input  disp_active,
   input  frame_end,
   input  line_end,
   output [7:0] r,
   output [7:0] g,
   output [7:0] b);
  wire [9:0] shader_counter_reg;
  wire [9:0] shader_counter_next;
  wire [9:0] temp_r;
  wire [9:0] temp_g;
  wire [9:0] temp_b;
  wire [7:0] n556;
  wire [7:0] n557;
  wire [7:0] n558;
  wire [9:0] n562;
  wire [9:0] n570;
  wire [9:0] n571;
  wire [9:0] n572;
  wire [9:0] n573;
  wire [9:0] n574;
  wire [30:0] n575;
  wire [30:0] n577;
  wire [9:0] n578;
  wire [9:0] n579;
  wire [9:0] n580;
  wire [9:0] n581;
  wire [30:0] n582;
  wire [30:0] n584;
  wire [9:0] n585;
  wire [9:0] n586;
  wire n588;
  wire [9:0] n591;
  wire [9:0] n593;
  wire [9:0] n594;
  wire [9:0] n595;
  wire [30:0] n596;
  wire [30:0] n598;
  wire [9:0] n599;
  wire [9:0] n600;
  wire [9:0] n602;
  wire [9:0] n603;
  wire [9:0] n604;
  wire [30:0] n605;
  wire [30:0] n607;
  wire [9:0] n608;
  wire [9:0] n609;
  wire n611;
  wire [9:0] n614;
  wire [9:0] n616;
  wire [9:0] n618;
  wire [9:0] n619;
  wire [9:0] n621;
  wire [9:0] n622;
  wire [30:0] n623;
  wire [30:0] n625;
  wire [9:0] n626;
  wire [9:0] n627;
  wire [9:0] n629;
  wire [9:0] n630;
  wire [9:0] n632;
  wire [9:0] n633;
  wire [30:0] n634;
  wire [30:0] n636;
  wire [9:0] n637;
  wire [9:0] n638;
  wire n640;
  wire [9:0] n643;
  reg [9:0] n646;
  assign r = n556; //(module output)
  assign g = n558; //(module output)
  assign b = n557; //(module output)
  /* shader.vhdl:25:12  */
  assign shader_counter_reg = n646; // (signal)
  /* shader.vhdl:25:32  */
  assign shader_counter_next = n571; // (signal)
  /* shader.vhdl:27:12  */
  assign temp_r = n643; // (signal)
  /* shader.vhdl:27:20  */
  assign temp_g = n614; // (signal)
  /* shader.vhdl:27:28  */
  assign temp_b = n591; // (signal)
  /* shader.vhdl:31:33  */
  assign n556 = temp_r[7:0]; // extract
  /* shader.vhdl:32:33  */
  assign n557 = temp_b[7:0]; // extract
  /* shader.vhdl:33:33  */
  assign n558 = temp_g[7:0]; // extract
  /* shader.vhdl:38:13  */
  assign n562 = reset ? 10'b0000000000 : shader_counter_next;
  /* shader.vhdl:58:55  */
  assign n570 = shader_counter_reg + 10'b0000000001;
  /* shader.vhdl:57:9  */
  assign n571 = frame_end ? n570 : shader_counter_reg;
  /* shader.vhdl:62:56  */
  assign n572 = video_y + shader_counter_reg;
  /* shader.vhdl:62:91  */
  assign n573 = video_x + shader_counter_reg;
  /* shader.vhdl:62:78  */
  assign n574 = n572 ^ n573;
  /* shader.vhdl:62:114  */
  assign n575 = {21'b0, n574};  //  uext
  /* shader.vhdl:62:114  */
  assign n577 = n575 % 31'b0000000000000000000000000000111; // umod
  /* shader.vhdl:62:114  */
  assign n578 = n577[9:0];  // trunc
  /* shader.vhdl:63:47  */
  assign n579 = video_y + shader_counter_reg;
  /* shader.vhdl:63:82  */
  assign n580 = video_x + shader_counter_reg;
  /* shader.vhdl:63:69  */
  assign n581 = n579 ^ n580;
  /* shader.vhdl:63:105  */
  assign n582 = {21'b0, n581};  //  uext
  /* shader.vhdl:63:105  */
  assign n584 = n582 % 31'b0000000000000000000000000001001; // umod
  /* shader.vhdl:63:105  */
  assign n585 = n584[9:0];  // trunc
  /* shader.vhdl:62:121  */
  assign n586 = n578 | n585;
  /* shader.vhdl:63:112  */
  assign n588 = $unsigned(n586) > $unsigned(10'b0000000001);
  /* shader.vhdl:62:9  */
  assign n591 = n588 ? 10'b1111111111 : 10'b0000000000;
  /* shader.vhdl:67:56  */
  assign n593 = video_y + shader_counter_reg;
  /* shader.vhdl:67:91  */
  assign n594 = video_x + shader_counter_reg;
  /* shader.vhdl:67:78  */
  assign n595 = n593 ^ n594;
  /* shader.vhdl:67:114  */
  assign n596 = {21'b0, n595};  //  uext
  /* shader.vhdl:67:114  */
  assign n598 = n596 % 31'b0000000000000000000000000000111; // umod
  /* shader.vhdl:67:114  */
  assign n599 = n598[9:0];  // trunc
  /* shader.vhdl:68:47  */
  assign n600 = video_y + shader_counter_reg;
  /* shader.vhdl:68:68  */
  assign n602 = n600 + 10'b0000000001;
  /* shader.vhdl:68:86  */
  assign n603 = video_x + shader_counter_reg;
  /* shader.vhdl:68:73  */
  assign n604 = n602 ^ n603;
  /* shader.vhdl:68:109  */
  assign n605 = {21'b0, n604};  //  uext
  /* shader.vhdl:68:109  */
  assign n607 = n605 % 31'b0000000000000000000000000001001; // umod
  /* shader.vhdl:68:109  */
  assign n608 = n607[9:0];  // trunc
  /* shader.vhdl:67:121  */
  assign n609 = n599 | n608;
  /* shader.vhdl:68:116  */
  assign n611 = $unsigned(n609) > $unsigned(10'b0000000001);
  /* shader.vhdl:67:9  */
  assign n614 = n611 ? 10'b1111111111 : 10'b0000000000;
  /* shader.vhdl:72:56  */
  assign n616 = video_y + shader_counter_reg;
  /* shader.vhdl:72:77  */
  assign n618 = n616 + 10'b0000000001;
  /* shader.vhdl:72:95  */
  assign n619 = video_x + shader_counter_reg;
  /* shader.vhdl:72:116  */
  assign n621 = n619 + 10'b0000000001;
  /* shader.vhdl:72:82  */
  assign n622 = n618 ^ n621;
  /* shader.vhdl:72:122  */
  assign n623 = {21'b0, n622};  //  uext
  /* shader.vhdl:72:122  */
  assign n625 = n623 % 31'b0000000000000000000000000000111; // umod
  /* shader.vhdl:72:122  */
  assign n626 = n625[9:0];  // trunc
  /* shader.vhdl:73:47  */
  assign n627 = video_y + shader_counter_reg;
  /* shader.vhdl:73:67  */
  assign n629 = n627 + 10'b0000000010;
  /* shader.vhdl:73:84  */
  assign n630 = video_x + shader_counter_reg;
  /* shader.vhdl:73:103  */
  assign n632 = n630 + 10'b0000000001;
  /* shader.vhdl:73:72  */
  assign n633 = n629 ^ n632;
  /* shader.vhdl:73:108  */
  assign n634 = {21'b0, n633};  //  uext
  /* shader.vhdl:73:108  */
  assign n636 = n634 % 31'b0000000000000000000000000001001; // umod
  /* shader.vhdl:73:108  */
  assign n637 = n636[9:0];  // trunc
  /* shader.vhdl:72:129  */
  assign n638 = n626 | n637;
  /* shader.vhdl:73:115  */
  assign n640 = $unsigned(n638) > $unsigned(10'b0000000001);
  /* shader.vhdl:72:9  */
  assign n643 = n640 ? 10'b0000000000 : 10'b1111111111;
  /* shader.vhdl:36:9  */
  always @(posedge clk)
    n646 <= n562;
endmodule

