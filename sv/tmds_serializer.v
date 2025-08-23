`timescale 1ns / 1ps
module tmds_serializer
  (input  serclk,
   input  rst,
   input  [9:0] tmds_parallel_r,
   input  [9:0] tmds_parallel_g,
   input  [9:0] tmds_parallel_b,
   output tmds_serial_r,
   output tmds_serial_g,
   output tmds_serial_b,
   output tmds_serial_c);
  reg [9:0] shift_reg_r;
  reg [9:0] shift_reg_g;
  reg [9:0] shift_reg_b;
  reg [9:0] shift_reg_c;
  reg [2:0] bit_cnt;
  wire [31:0] n408;
  wire n410;
  wire [7:0] n411;
  wire [9:0] n413;
  wire [7:0] n414;
  wire [9:0] n416;
  wire [7:0] n417;
  wire [9:0] n419;
  wire [7:0] n420;
  wire [9:0] n422;
  wire [31:0] n423;
  wire [31:0] n425;
  wire [2:0] n426;
  wire [9:0] n427;
  wire [9:0] n428;
  wire [9:0] n429;
  wire [9:0] n431;
  wire [2:0] n433;
  wire n450;
  wire n451;
  wire n452;
  wire n453;
  wire n454;
  wire n455;
  wire n456;
  wire n457;
  wire n458;
  wire n459;
  wire n460;
  wire n461;
  reg [9:0] n462;
  reg [9:0] n463;
  reg [9:0] n464;
  reg [9:0] n465;
  reg [2:0] n466;
  assign tmds_serial_r = n451; //(module output)
  assign tmds_serial_g = n454; //(module output)
  assign tmds_serial_b = n457; //(module output)
  assign tmds_serial_c = n460; //(module output)
  /* TMDS_serializer.vhdl:36:12  */
  always @*
    shift_reg_r = n462; // (isignal)
  initial
    shift_reg_r = 10'b0000000000;
  /* TMDS_serializer.vhdl:37:12  */
  always @*
    shift_reg_g = n463; // (isignal)
  initial
    shift_reg_g = 10'b0000000000;
  /* TMDS_serializer.vhdl:38:12  */
  always @*
    shift_reg_b = n464; // (isignal)
  initial
    shift_reg_b = 10'b0000000000;
  /* TMDS_serializer.vhdl:39:12  */
  always @*
    shift_reg_c = n465; // (isignal)
  initial
    shift_reg_c = 10'b0000000000;
  /* TMDS_serializer.vhdl:40:12  */
  always @*
    bit_cnt = n466; // (isignal)
  initial
    bit_cnt = 3'b100;
  /* TMDS_serializer.vhdl:53:24  */
  assign n408 = {29'b0, bit_cnt};  //  uext
  /* TMDS_serializer.vhdl:53:24  */
  assign n410 = n408 == 32'b00000000000000000000000000000100;
  /* TMDS_serializer.vhdl:60:50  */
  assign n411 = shift_reg_r[9:2]; // extract
  /* TMDS_serializer.vhdl:60:37  */
  assign n413 = {2'b00, n411};
  /* TMDS_serializer.vhdl:61:50  */
  assign n414 = shift_reg_g[9:2]; // extract
  /* TMDS_serializer.vhdl:61:37  */
  assign n416 = {2'b00, n414};
  /* TMDS_serializer.vhdl:62:50  */
  assign n417 = shift_reg_b[9:2]; // extract
  /* TMDS_serializer.vhdl:62:37  */
  assign n419 = {2'b00, n417};
  /* TMDS_serializer.vhdl:63:50  */
  assign n420 = shift_reg_c[9:2]; // extract
  /* TMDS_serializer.vhdl:63:37  */
  assign n422 = {2'b00, n420};
  /* TMDS_serializer.vhdl:64:38  */
  assign n423 = {29'b0, bit_cnt};  //  uext
  /* TMDS_serializer.vhdl:64:38  */
  assign n425 = n423 + 32'b00000000000000000000000000000001;
  /* TMDS_serializer.vhdl:64:30  */
  assign n426 = n425[2:0];  // trunc
  /* TMDS_serializer.vhdl:53:13  */
  assign n427 = n410 ? tmds_parallel_r : n413;
  /* TMDS_serializer.vhdl:53:13  */
  assign n428 = n410 ? tmds_parallel_g : n416;
  /* TMDS_serializer.vhdl:53:13  */
  assign n429 = n410 ? tmds_parallel_b : n419;
  /* TMDS_serializer.vhdl:53:13  */
  assign n431 = n410 ? 10'b1111100000 : n422;
  /* TMDS_serializer.vhdl:53:13  */
  assign n433 = n410 ? 3'b000 : n426;
  /* TMDS_serializer.vhdl:69:33  */
  assign n450 = shift_reg_r[0]; // extract
  /* TMDS_serializer.vhdl:69:37  */
  assign n451 = serclk ? n450 : n452;
  /* TMDS_serializer.vhdl:69:71  */
  assign n452 = shift_reg_r[1]; // extract
  /* TMDS_serializer.vhdl:70:33  */
  assign n453 = shift_reg_g[0]; // extract
  /* TMDS_serializer.vhdl:70:37  */
  assign n454 = serclk ? n453 : n455;
  /* TMDS_serializer.vhdl:70:71  */
  assign n455 = shift_reg_g[1]; // extract
  /* TMDS_serializer.vhdl:71:33  */
  assign n456 = shift_reg_b[0]; // extract
  /* TMDS_serializer.vhdl:71:37  */
  assign n457 = serclk ? n456 : n458;
  /* TMDS_serializer.vhdl:71:71  */
  assign n458 = shift_reg_b[1]; // extract
  /* TMDS_serializer.vhdl:72:33  */
  assign n459 = shift_reg_c[0]; // extract
  /* TMDS_serializer.vhdl:72:37  */
  assign n460 = serclk ? n459 : n461;
  /* TMDS_serializer.vhdl:72:71  */
  assign n461 = shift_reg_c[1]; // extract
  /* TMDS_serializer.vhdl:52:9  */
  always @(posedge serclk or posedge rst)
    if (rst)
      n462 <= 10'b0000000000;
    else
      n462 <= n427;
  /* TMDS_serializer.vhdl:52:9  */
  always @(posedge serclk or posedge rst)
    if (rst)
      n463 <= 10'b0000000000;
    else
      n463 <= n428;
  /* TMDS_serializer.vhdl:52:9  */
  always @(posedge serclk or posedge rst)
    if (rst)
      n464 <= 10'b0000000000;
    else
      n464 <= n429;
  /* TMDS_serializer.vhdl:52:9  */
  always @(posedge serclk or posedge rst)
    if (rst)
      n465 <= 10'b0000000000;
    else
      n465 <= n431;
  /* TMDS_serializer.vhdl:52:9  */
  always @(posedge serclk or posedge rst)
    if (rst)
      n466 <= 3'b100;
    else
      n466 <= n433;
endmodule