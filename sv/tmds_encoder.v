`timescale 1ns / 1ps
module tmds_encoder
  (input  clk,
   input  reset,
   input  disp_enable,
   input  hsync,
   input  vsync,
   input  [7:0] color_data,
   output [9:0] tmds_encoded);
  wire [9:0] tmds_output_next;
  wire [9:0] tmds_output_reg;
  wire [4:0] dc_balancing_reg;
  wire [4:0] dc_balancing_next;
  wire [7:0] xored_color_data;
  wire [7:0] xnored_color_data;
  wire n94;
  wire n95;
  wire n96;
  wire n97;
  wire n98;
  wire n99;
  wire n100;
  wire n101;
  wire n102;
  wire n103;
  wire n104;
  wire n105;
  wire n106;
  wire n107;
  wire n108;
  wire n109;
  wire n110;
  wire n111;
  wire n112;
  wire n113;
  wire n114;
  wire n115;
  wire n116;
  wire n117;
  wire n118;
  wire n119;
  wire n120;
  wire n121;
  wire n122;
  wire n123;
  wire n124;
  wire n125;
  wire n126;
  wire n127;
  wire n128;
  wire n129;
  wire n130;
  wire n131;
  wire n132;
  wire n133;
  wire n134;
  wire n135;
  wire n136;
  wire n137;
  wire [9:0] n141;
  wire [4:0] n143;
  wire n158;
  wire [30:0] n161;
  wire n163;
  wire [31:0] n164;
  wire [31:0] n166;
  wire [30:0] n167;
  wire [30:0] n168;
  wire n169;
  wire [31:0] n170;
  wire [31:0] n172;
  wire [30:0] n173;
  wire [30:0] n174;
  wire n175;
  wire [31:0] n176;
  wire [31:0] n178;
  wire [30:0] n179;
  wire [30:0] n180;
  wire n181;
  wire [31:0] n182;
  wire [31:0] n184;
  wire [30:0] n185;
  wire [30:0] n186;
  wire n187;
  wire [31:0] n188;
  wire [31:0] n190;
  wire [30:0] n191;
  wire [30:0] n192;
  wire n193;
  wire [31:0] n194;
  wire [31:0] n196;
  wire [30:0] n197;
  wire [30:0] n198;
  wire n199;
  wire [31:0] n200;
  wire [31:0] n202;
  wire [30:0] n203;
  wire [30:0] n204;
  wire [3:0] n205;
  wire [31:0] n206;
  wire n208;
  wire [31:0] n209;
  wire n211;
  wire n212;
  wire n213;
  wire n214;
  wire n215;
  wire [8:0] n217;
  wire [8:0] n219;
  wire [8:0] n220;
  wire [8:0] n223;
  wire n229;
  wire [30:0] n232;
  wire n234;
  wire [31:0] n235;
  wire [31:0] n237;
  wire [30:0] n238;
  wire [30:0] n239;
  wire n240;
  wire [31:0] n241;
  wire [31:0] n243;
  wire [30:0] n244;
  wire [30:0] n245;
  wire n246;
  wire [31:0] n247;
  wire [31:0] n249;
  wire [30:0] n250;
  wire [30:0] n251;
  wire n252;
  wire [31:0] n253;
  wire [31:0] n255;
  wire [30:0] n256;
  wire [30:0] n257;
  wire n258;
  wire [31:0] n259;
  wire [31:0] n261;
  wire [30:0] n262;
  wire [30:0] n263;
  wire n264;
  wire [31:0] n265;
  wire [31:0] n267;
  wire [30:0] n268;
  wire [30:0] n269;
  wire n270;
  wire [31:0] n271;
  wire [31:0] n273;
  wire [30:0] n274;
  wire [30:0] n275;
  wire n276;
  wire [31:0] n277;
  wire [31:0] n279;
  wire [30:0] n280;
  wire [30:0] n281;
  wire [3:0] n282;
  wire [31:0] n283;
  wire [31:0] n285;
  wire [3:0] n286;
  wire n287;
  wire n288;
  wire n289;
  wire n290;
  wire n291;
  wire n292;
  wire n293;
  wire n294;
  wire [9:0] n297;
  wire [9:0] n299;
  wire [9:0] n301;
  wire n303;
  wire [31:0] n304;
  wire n306;
  wire n307;
  wire n308;
  wire n309;
  wire n310;
  wire [9:0] n311;
  wire [4:0] n313;
  wire [4:0] n314;
  wire [4:0] n316;
  wire [4:0] n317;
  wire n318;
  wire n319;
  wire n320;
  wire [1:0] n321;
  wire [7:0] n322;
  wire [7:0] n323;
  wire [9:0] n324;
  wire [4:0] n326;
  wire [4:0] n327;
  wire [4:0] n329;
  wire [4:0] n330;
  wire [9:0] n331;
  wire [4:0] n332;
  wire n334;
  wire [31:0] n335;
  wire n337;
  wire n338;
  wire n340;
  wire [31:0] n341;
  wire n343;
  wire n344;
  wire n345;
  wire n346;
  wire [1:0] n348;
  wire [7:0] n349;
  wire [7:0] n350;
  wire [9:0] n351;
  wire [4:0] n353;
  wire [4:0] n354;
  wire [4:0] n356;
  wire [4:0] n357;
  wire [1:0] n358;
  wire [1:0] n360;
  wire [30:0] n361;
  wire [4:0] n363;
  wire [4:0] n364;
  wire n365;
  wire [1:0] n367;
  wire [7:0] n368;
  wire [9:0] n369;
  wire [4:0] n371;
  wire [4:0] n372;
  wire [4:0] n374;
  wire [4:0] n375;
  wire [1:0] n376;
  wire [1:0] n377;
  wire [1:0] n379;
  wire [30:0] n380;
  wire [4:0] n382;
  wire [4:0] n383;
  wire [9:0] n384;
  wire [4:0] n385;
  wire [9:0] n386;
  wire [4:0] n387;
  wire [9:0] n388;
  wire [4:0] n390;
  reg [9:0] n392;
  reg [4:0] n393;
  wire [7:0] n394;
  wire [7:0] n395;
  assign tmds_encoded = tmds_output_reg; //(module output)
  /* tmds_encoder.vhdl:49:12  */
  assign tmds_output_next = n388; // (signal)
  /* tmds_encoder.vhdl:49:30  */
  assign tmds_output_reg = n392; // (signal)
  /* tmds_encoder.vhdl:52:12  */
  assign dc_balancing_reg = n393; // (signal)
  /* tmds_encoder.vhdl:52:30  */
  assign dc_balancing_next = n390; // (signal)
  /* tmds_encoder.vhdl:55:12  */
  assign xored_color_data = n394; // (signal)
  /* tmds_encoder.vhdl:55:30  */
  assign xnored_color_data = n395; // (signal)
  /* tmds_encoder.vhdl:70:38  */
  assign n94 = color_data[0]; // extract
  /* tmds_encoder.vhdl:71:39  */
  assign n95 = color_data[0]; // extract
  /* tmds_encoder.vhdl:75:46  */
  assign n96 = color_data[1]; // extract
  /* tmds_encoder.vhdl:75:71  */
  assign n97 = xnored_color_data[0]; // extract
  /* tmds_encoder.vhdl:75:50  */
  assign n98 = n96 ^ n97;
  /* tmds_encoder.vhdl:76:46  */
  assign n99 = color_data[1]; // extract
  /* tmds_encoder.vhdl:76:71  */
  assign n100 = xored_color_data[0]; // extract
  /* tmds_encoder.vhdl:76:50  */
  assign n101 = ~(n99 ^ n100);
  /* tmds_encoder.vhdl:75:46  */
  assign n102 = color_data[2]; // extract
  /* tmds_encoder.vhdl:75:71  */
  assign n103 = xnored_color_data[1]; // extract
  /* tmds_encoder.vhdl:75:50  */
  assign n104 = n102 ^ n103;
  /* tmds_encoder.vhdl:76:46  */
  assign n105 = color_data[2]; // extract
  /* tmds_encoder.vhdl:76:71  */
  assign n106 = xored_color_data[1]; // extract
  /* tmds_encoder.vhdl:76:50  */
  assign n107 = ~(n105 ^ n106);
  /* tmds_encoder.vhdl:75:46  */
  assign n108 = color_data[3]; // extract
  /* tmds_encoder.vhdl:75:71  */
  assign n109 = xnored_color_data[2]; // extract
  /* tmds_encoder.vhdl:75:50  */
  assign n110 = n108 ^ n109;
  /* tmds_encoder.vhdl:76:46  */
  assign n111 = color_data[3]; // extract
  /* tmds_encoder.vhdl:76:71  */
  assign n112 = xored_color_data[2]; // extract
  /* tmds_encoder.vhdl:76:50  */
  assign n113 = ~(n111 ^ n112);
  /* tmds_encoder.vhdl:75:46  */
  assign n114 = color_data[4]; // extract
  /* tmds_encoder.vhdl:75:71  */
  assign n115 = xnored_color_data[3]; // extract
  /* tmds_encoder.vhdl:75:50  */
  assign n116 = n114 ^ n115;
  /* tmds_encoder.vhdl:76:46  */
  assign n117 = color_data[4]; // extract
  /* tmds_encoder.vhdl:76:71  */
  assign n118 = xored_color_data[3]; // extract
  /* tmds_encoder.vhdl:76:50  */
  assign n119 = ~(n117 ^ n118);
  /* tmds_encoder.vhdl:75:46  */
  assign n120 = color_data[5]; // extract
  /* tmds_encoder.vhdl:75:71  */
  assign n121 = xnored_color_data[4]; // extract
  /* tmds_encoder.vhdl:75:50  */
  assign n122 = n120 ^ n121;
  /* tmds_encoder.vhdl:76:46  */
  assign n123 = color_data[5]; // extract
  /* tmds_encoder.vhdl:76:71  */
  assign n124 = xored_color_data[4]; // extract
  /* tmds_encoder.vhdl:76:50  */
  assign n125 = ~(n123 ^ n124);
  /* tmds_encoder.vhdl:75:46  */
  assign n126 = color_data[6]; // extract
  /* tmds_encoder.vhdl:75:71  */
  assign n127 = xnored_color_data[5]; // extract
  /* tmds_encoder.vhdl:75:50  */
  assign n128 = n126 ^ n127;
  /* tmds_encoder.vhdl:76:46  */
  assign n129 = color_data[6]; // extract
  /* tmds_encoder.vhdl:76:71  */
  assign n130 = xored_color_data[5]; // extract
  /* tmds_encoder.vhdl:76:50  */
  assign n131 = ~(n129 ^ n130);
  /* tmds_encoder.vhdl:75:46  */
  assign n132 = color_data[7]; // extract
  /* tmds_encoder.vhdl:75:71  */
  assign n133 = xnored_color_data[6]; // extract
  /* tmds_encoder.vhdl:75:50  */
  assign n134 = n132 ^ n133;
  /* tmds_encoder.vhdl:76:46  */
  assign n135 = color_data[7]; // extract
  /* tmds_encoder.vhdl:76:71  */
  assign n136 = xored_color_data[6]; // extract
  /* tmds_encoder.vhdl:76:50  */
  assign n137 = ~(n135 ^ n136);
  /* tmds_encoder.vhdl:82:13  */
  assign n141 = reset ? 10'b0000000000 : tmds_output_next;
  /* tmds_encoder.vhdl:82:13  */
  assign n143 = reset ? 5'b00000 : dc_balancing_next;
  /* tmds_encoder.vhdl:62:17  */
  assign n158 = color_data[7]; // extract
  /* tmds_encoder.vhdl:62:13  */
  assign n161 = n158 ? 31'b0000000000000000000000000000001 : 31'b0000000000000000000000000000000;
  /* tmds_encoder.vhdl:62:17  */
  assign n163 = color_data[6]; // extract
  /* tmds_encoder.vhdl:63:30  */
  assign n164 = {1'b0, n161};  //  uext
  /* tmds_encoder.vhdl:63:30  */
  assign n166 = n164 + 32'b00000000000000000000000000000001;
  /* tmds_encoder.vhdl:63:17  */
  assign n167 = n166[30:0];  // trunc
  /* tmds_encoder.vhdl:62:13  */
  assign n168 = n163 ? n167 : n161;
  /* tmds_encoder.vhdl:62:17  */
  assign n169 = color_data[5]; // extract
  /* tmds_encoder.vhdl:63:30  */
  assign n170 = {1'b0, n168};  //  uext
  /* tmds_encoder.vhdl:63:30  */
  assign n172 = n170 + 32'b00000000000000000000000000000001;
  /* tmds_encoder.vhdl:63:17  */
  assign n173 = n172[30:0];  // trunc
  /* tmds_encoder.vhdl:62:13  */
  assign n174 = n169 ? n173 : n168;
  /* tmds_encoder.vhdl:62:17  */
  assign n175 = color_data[4]; // extract
  /* tmds_encoder.vhdl:63:30  */
  assign n176 = {1'b0, n174};  //  uext
  /* tmds_encoder.vhdl:63:30  */
  assign n178 = n176 + 32'b00000000000000000000000000000001;
  /* tmds_encoder.vhdl:63:17  */
  assign n179 = n178[30:0];  // trunc
  /* tmds_encoder.vhdl:62:13  */
  assign n180 = n175 ? n179 : n174;
  /* tmds_encoder.vhdl:62:17  */
  assign n181 = color_data[3]; // extract
  /* tmds_encoder.vhdl:63:30  */
  assign n182 = {1'b0, n180};  //  uext
  /* tmds_encoder.vhdl:63:30  */
  assign n184 = n182 + 32'b00000000000000000000000000000001;
  /* tmds_encoder.vhdl:63:17  */
  assign n185 = n184[30:0];  // trunc
  /* tmds_encoder.vhdl:62:13  */
  assign n186 = n181 ? n185 : n180;
  /* tmds_encoder.vhdl:62:17  */
  assign n187 = color_data[2]; // extract
  /* tmds_encoder.vhdl:63:30  */
  assign n188 = {1'b0, n186};  //  uext
  /* tmds_encoder.vhdl:63:30  */
  assign n190 = n188 + 32'b00000000000000000000000000000001;
  /* tmds_encoder.vhdl:63:17  */
  assign n191 = n190[30:0];  // trunc
  /* tmds_encoder.vhdl:62:13  */
  assign n192 = n187 ? n191 : n186;
  /* tmds_encoder.vhdl:62:17  */
  assign n193 = color_data[1]; // extract
  /* tmds_encoder.vhdl:63:30  */
  assign n194 = {1'b0, n192};  //  uext
  /* tmds_encoder.vhdl:63:30  */
  assign n196 = n194 + 32'b00000000000000000000000000000001;
  /* tmds_encoder.vhdl:63:17  */
  assign n197 = n196[30:0];  // trunc
  /* tmds_encoder.vhdl:62:13  */
  assign n198 = n193 ? n197 : n192;
  /* tmds_encoder.vhdl:62:17  */
  assign n199 = color_data[0]; // extract
  /* tmds_encoder.vhdl:63:30  */
  assign n200 = {1'b0, n198};  //  uext
  /* tmds_encoder.vhdl:63:30  */
  assign n202 = n200 + 32'b00000000000000000000000000000001;
  /* tmds_encoder.vhdl:63:17  */
  assign n203 = n202[30:0];  // trunc
  /* tmds_encoder.vhdl:62:13  */
  assign n204 = n199 ? n203 : n198;
  /* tmds_encoder.vhdl:106:9  */
  assign n205 = n204[3:0];  // trunc
  /* tmds_encoder.vhdl:110:50  */
  assign n206 = {28'b0, n205};  //  uext
  /* tmds_encoder.vhdl:110:50  */
  assign n208 = $signed(n206) > $signed(32'b00000000000000000000000000000100);
  /* tmds_encoder.vhdl:111:45  */
  assign n209 = {28'b0, n205};  //  uext
  /* tmds_encoder.vhdl:111:45  */
  assign n211 = n209 == 32'b00000000000000000000000000000100;
  /* tmds_encoder.vhdl:111:65  */
  assign n212 = color_data[0]; // extract
  /* tmds_encoder.vhdl:111:69  */
  assign n213 = ~n212;
  /* tmds_encoder.vhdl:111:50  */
  assign n214 = n213 & n211;
  /* tmds_encoder.vhdl:110:55  */
  assign n215 = n208 | n214;
  /* tmds_encoder.vhdl:112:38  */
  assign n217 = {1'b0, xored_color_data};
  /* tmds_encoder.vhdl:114:38  */
  assign n219 = {1'b1, xnored_color_data};
  /* tmds_encoder.vhdl:110:9  */
  assign n220 = n215 ? n217 : n219;
  /* tmds_encoder.vhdl:118:60  */
  assign n223 = n220 & 9'b011111111;
  /* tmds_encoder.vhdl:62:17  */
  assign n229 = n223[8]; // extract
  /* tmds_encoder.vhdl:62:13  */
  assign n232 = n229 ? 31'b0000000000000000000000000000001 : 31'b0000000000000000000000000000000;
  /* tmds_encoder.vhdl:62:17  */
  assign n234 = n223[7]; // extract
  /* tmds_encoder.vhdl:63:30  */
  assign n235 = {1'b0, n232};  //  uext
  /* tmds_encoder.vhdl:63:30  */
  assign n237 = n235 + 32'b00000000000000000000000000000001;
  /* tmds_encoder.vhdl:63:17  */
  assign n238 = n237[30:0];  // trunc
  /* tmds_encoder.vhdl:62:13  */
  assign n239 = n234 ? n238 : n232;
  /* tmds_encoder.vhdl:62:17  */
  assign n240 = n223[6]; // extract
  /* tmds_encoder.vhdl:63:30  */
  assign n241 = {1'b0, n239};  //  uext
  /* tmds_encoder.vhdl:63:30  */
  assign n243 = n241 + 32'b00000000000000000000000000000001;
  /* tmds_encoder.vhdl:63:17  */
  assign n244 = n243[30:0];  // trunc
  /* tmds_encoder.vhdl:62:13  */
  assign n245 = n240 ? n244 : n239;
  /* tmds_encoder.vhdl:62:17  */
  assign n246 = n223[5]; // extract
  /* tmds_encoder.vhdl:63:30  */
  assign n247 = {1'b0, n245};  //  uext
  /* tmds_encoder.vhdl:63:30  */
  assign n249 = n247 + 32'b00000000000000000000000000000001;
  /* tmds_encoder.vhdl:63:17  */
  assign n250 = n249[30:0];  // trunc
  /* tmds_encoder.vhdl:62:13  */
  assign n251 = n246 ? n250 : n245;
  /* tmds_encoder.vhdl:62:17  */
  assign n252 = n223[4]; // extract
  /* tmds_encoder.vhdl:63:30  */
  assign n253 = {1'b0, n251};  //  uext
  /* tmds_encoder.vhdl:63:30  */
  assign n255 = n253 + 32'b00000000000000000000000000000001;
  /* tmds_encoder.vhdl:63:17  */
  assign n256 = n255[30:0];  // trunc
  /* tmds_encoder.vhdl:62:13  */
  assign n257 = n252 ? n256 : n251;
  /* tmds_encoder.vhdl:62:17  */
  assign n258 = n223[3]; // extract
  /* tmds_encoder.vhdl:63:30  */
  assign n259 = {1'b0, n257};  //  uext
  /* tmds_encoder.vhdl:63:30  */
  assign n261 = n259 + 32'b00000000000000000000000000000001;
  /* tmds_encoder.vhdl:63:17  */
  assign n262 = n261[30:0];  // trunc
  /* tmds_encoder.vhdl:62:13  */
  assign n263 = n258 ? n262 : n257;
  /* tmds_encoder.vhdl:62:17  */
  assign n264 = n223[2]; // extract
  /* tmds_encoder.vhdl:63:30  */
  assign n265 = {1'b0, n263};  //  uext
  /* tmds_encoder.vhdl:63:30  */
  assign n267 = n265 + 32'b00000000000000000000000000000001;
  /* tmds_encoder.vhdl:63:17  */
  assign n268 = n267[30:0];  // trunc
  /* tmds_encoder.vhdl:62:13  */
  assign n269 = n264 ? n268 : n263;
  /* tmds_encoder.vhdl:62:17  */
  assign n270 = n223[1]; // extract
  /* tmds_encoder.vhdl:63:30  */
  assign n271 = {1'b0, n269};  //  uext
  /* tmds_encoder.vhdl:63:30  */
  assign n273 = n271 + 32'b00000000000000000000000000000001;
  /* tmds_encoder.vhdl:63:17  */
  assign n274 = n273[30:0];  // trunc
  /* tmds_encoder.vhdl:62:13  */
  assign n275 = n270 ? n274 : n269;
  /* tmds_encoder.vhdl:62:17  */
  assign n276 = n223[0]; // extract
  /* tmds_encoder.vhdl:63:30  */
  assign n277 = {1'b0, n275};  //  uext
  /* tmds_encoder.vhdl:63:30  */
  assign n279 = n277 + 32'b00000000000000000000000000000001;
  /* tmds_encoder.vhdl:63:17  */
  assign n280 = n279[30:0];  // trunc
  /* tmds_encoder.vhdl:62:13  */
  assign n281 = n276 ? n280 : n275;
  /* tmds_encoder.vhdl:118:9  */
  assign n282 = n281[3:0];  // trunc
  /* tmds_encoder.vhdl:119:34  */
  assign n283 = {28'b0, n282};  //  uext
  /* tmds_encoder.vhdl:119:34  */
  assign n285 = 32'b00000000000000000000000000001000 - n283;
  /* tmds_encoder.vhdl:119:9  */
  assign n286 = n285[3:0];  // trunc
  /* tmds_encoder.vhdl:122:24  */
  assign n287 = ~disp_enable;
  /* tmds_encoder.vhdl:126:22  */
  assign n288 = ~vsync;
  /* tmds_encoder.vhdl:126:38  */
  assign n289 = ~hsync;
  /* tmds_encoder.vhdl:126:28  */
  assign n290 = n289 & n288;
  /* tmds_encoder.vhdl:128:25  */
  assign n291 = ~vsync;
  /* tmds_encoder.vhdl:128:31  */
  assign n292 = hsync & n291;
  /* tmds_encoder.vhdl:130:41  */
  assign n293 = ~hsync;
  /* tmds_encoder.vhdl:130:31  */
  assign n294 = n293 & vsync;
  /* tmds_encoder.vhdl:130:13  */
  assign n297 = n294 ? 10'b0101010100 : 10'b1010101011;
  /* tmds_encoder.vhdl:128:13  */
  assign n299 = n292 ? 10'b0010101011 : n297;
  /* tmds_encoder.vhdl:126:13  */
  assign n301 = n290 ? 10'b1101010100 : n299;
  /* tmds_encoder.vhdl:140:33  */
  assign n303 = dc_balancing_reg == 5'b00000;
  /* tmds_encoder.vhdl:140:59  */
  assign n304 = {28'b0, n282};  //  uext
  /* tmds_encoder.vhdl:140:59  */
  assign n306 = n304 == 32'b00000000000000000000000000000100;
  /* tmds_encoder.vhdl:140:37  */
  assign n307 = n303 | n306;
  /* tmds_encoder.vhdl:152:37  */
  assign n308 = n220[8]; // extract
  /* tmds_encoder.vhdl:153:63  */
  assign n309 = n220[8]; // extract
  /* tmds_encoder.vhdl:153:42  */
  assign n310 = ~n309;
  /* tmds_encoder.vhdl:153:68  */
  assign n311 = {n310, n220};
  /* tmds_encoder.vhdl:154:59  */
  assign n313 = {1'b0, n282};  //  uext
  /* tmds_encoder.vhdl:154:59  */
  assign n314 = dc_balancing_reg + n313;
  /* tmds_encoder.vhdl:154:80  */
  assign n316 = {1'b0, n286};  //  uext
  /* tmds_encoder.vhdl:154:80  */
  assign n317 = n314 - n316;
  /* tmds_encoder.vhdl:156:63  */
  assign n318 = n220[8]; // extract
  /* tmds_encoder.vhdl:156:42  */
  assign n319 = ~n318;
  /* tmds_encoder.vhdl:156:87  */
  assign n320 = n220[8]; // extract
  /* tmds_encoder.vhdl:156:68  */
  assign n321 = {n319, n320};
  /* tmds_encoder.vhdl:156:114  */
  assign n322 = n220[7:0]; // extract
  /* tmds_encoder.vhdl:156:93  */
  assign n323 = ~n322;
  /* tmds_encoder.vhdl:156:91  */
  assign n324 = {n321, n323};
  /* tmds_encoder.vhdl:157:59  */
  assign n326 = {1'b0, n282};  //  uext
  /* tmds_encoder.vhdl:157:59  */
  assign n327 = dc_balancing_reg - n326;
  /* tmds_encoder.vhdl:157:80  */
  assign n329 = {1'b0, n286};  //  uext
  /* tmds_encoder.vhdl:157:80  */
  assign n330 = n327 + n329;
  /* tmds_encoder.vhdl:152:17  */
  assign n331 = n308 ? n311 : n324;
  /* tmds_encoder.vhdl:152:17  */
  assign n332 = n308 ? n317 : n330;
  /* tmds_encoder.vhdl:164:38  */
  assign n334 = $signed(dc_balancing_reg) > $signed(5'b00000);
  /* tmds_encoder.vhdl:164:65  */
  assign n335 = {28'b0, n282};  //  uext
  /* tmds_encoder.vhdl:164:65  */
  assign n337 = $signed(n335) > $signed(32'b00000000000000000000000000000100);
  /* tmds_encoder.vhdl:164:42  */
  assign n338 = n337 & n334;
  /* tmds_encoder.vhdl:165:38  */
  assign n340 = $signed(dc_balancing_reg) < $signed(5'b00000);
  /* tmds_encoder.vhdl:165:65  */
  assign n341 = {28'b0, n282};  //  uext
  /* tmds_encoder.vhdl:165:65  */
  assign n343 = $signed(n341) < $signed(32'b00000000000000000000000000000100);
  /* tmds_encoder.vhdl:165:42  */
  assign n344 = n343 & n340;
  /* tmds_encoder.vhdl:164:70  */
  assign n345 = n338 | n344;
  /* tmds_encoder.vhdl:169:64  */
  assign n346 = n220[8]; // extract
  /* tmds_encoder.vhdl:169:45  */
  assign n348 = {1'b1, n346};
  /* tmds_encoder.vhdl:169:91  */
  assign n349 = n220[7:0]; // extract
  /* tmds_encoder.vhdl:169:70  */
  assign n350 = ~n349;
  /* tmds_encoder.vhdl:169:68  */
  assign n351 = {n348, n350};
  /* tmds_encoder.vhdl:172:59  */
  assign n353 = {1'b0, n282};  //  uext
  /* tmds_encoder.vhdl:172:59  */
  assign n354 = dc_balancing_reg - n353;
  /* tmds_encoder.vhdl:172:80  */
  assign n356 = {1'b0, n286};  //  uext
  /* tmds_encoder.vhdl:172:80  */
  assign n357 = n354 + n356;
  /* tmds_encoder.vhdl:172:141  */
  assign n358 = n220[8:7]; // extract
  /* tmds_encoder.vhdl:172:154  */
  assign n360 = n358 & 2'b10;
  /* tmds_encoder.vhdl:172:104  */
  assign n361 = {29'b0, n360};  //  uext
  /* tmds_encoder.vhdl:172:102  */
  assign n363 = n361[4:0];  // trunc
  /* tmds_encoder.vhdl:172:102  */
  assign n364 = n357 + n363;
  /* tmds_encoder.vhdl:177:64  */
  assign n365 = n220[8]; // extract
  /* tmds_encoder.vhdl:177:45  */
  assign n367 = {1'b0, n365};
  /* tmds_encoder.vhdl:177:87  */
  assign n368 = n220[7:0]; // extract
  /* tmds_encoder.vhdl:177:68  */
  assign n369 = {n367, n368};
  /* tmds_encoder.vhdl:180:59  */
  assign n371 = {1'b0, n282};  //  uext
  /* tmds_encoder.vhdl:180:59  */
  assign n372 = dc_balancing_reg + n371;
  /* tmds_encoder.vhdl:180:80  */
  assign n374 = {1'b0, n286};  //  uext
  /* tmds_encoder.vhdl:180:80  */
  assign n375 = n372 - n374;
  /* tmds_encoder.vhdl:180:146  */
  assign n376 = n220[8:7]; // extract
  /* tmds_encoder.vhdl:180:125  */
  assign n377 = ~n376;
  /* tmds_encoder.vhdl:180:160  */
  assign n379 = n377 & 2'b10;
  /* tmds_encoder.vhdl:180:104  */
  assign n380 = {29'b0, n379};  //  uext
  /* tmds_encoder.vhdl:180:102  */
  assign n382 = n380[4:0];  // trunc
  /* tmds_encoder.vhdl:180:102  */
  assign n383 = n375 - n382;
  /* tmds_encoder.vhdl:164:17  */
  assign n384 = n345 ? n351 : n369;
  /* tmds_encoder.vhdl:164:17  */
  assign n385 = n345 ? n364 : n383;
  /* tmds_encoder.vhdl:140:13  */
  assign n386 = n307 ? n331 : n384;
  /* tmds_encoder.vhdl:140:13  */
  assign n387 = n307 ? n332 : n385;
  /* tmds_encoder.vhdl:122:9  */
  assign n388 = n287 ? n301 : n386;
  /* tmds_encoder.vhdl:122:9  */
  assign n390 = n287 ? 5'b00000 : n387;
  /* tmds_encoder.vhdl:81:9  */
  always @(posedge clk)
    n392 <= n141;
  /* tmds_encoder.vhdl:81:9  */
  always @(posedge clk)
    n393 <= n143;
  /* tmds_encoder.vhdl:81:9  */
  assign n394 = {n137, n131, n125, n119, n113, n107, n101, n94};
  assign n395 = {n134, n128, n122, n116, n110, n104, n98, n95};
endmodule