// SPDX-FileCopyrightText: © 2025 XXX Authors
// SPDX-License-Identifier: Apache-2.0

module nano9k_top (
    input  CLK,     // 27 MHz
    input  RST_N,   // S1 Button by default

    // Onboard peripherals
    output logic [5:0] LEDS_N,
    input logic BTN_N,         // S2 Button

    // HDMI
    output logic [2:0] TMDS_D_P,
    output logic [2:0] TMDS_D_N,
    output logic TMDS_CLK_P,
    output logic TMDS_CLK_N,

    // Pascal Tang Nano 9K Baseboard mappings
    // https://github.com/gfcwfzkm/t9k-baseboard
    // PMOD 1
    input logic P1_1,
    input logic P1_2,
    input logic P1_3,
    input logic P1_4,
    input logic P1_5,
    input logic P1_6,
    input logic P1_7,
    input logic P1_8,

    // PMOD 2
    input logic P2_1,
    input logic P2_2,
    input logic P2_3,
    input logic P2_4,
    input logic P2_5,
    input logic P2_6,
    input logic P2_7,
    input logic P2_8,

    // PMOD 3
    input logic P3_1,
    input logic P3_2,
    input logic P3_3,
    input logic P3_4,
    input logic P3_5,
    input logic P3_6,
    input logic P3_7,
    input logic P3_8,

    // PMOD 4
    input logic P4_1,
    input logic P4_2,
    input logic P4_3,
    input logic P4_4
);
  
    // Input frequency:        27.000 MHz
    // Requested frequency:    125.875 MHz
    // Achieved frequency:     126 MHz
    
    logic locked;
    logic clk_100;
  
     rPLL #( // For GW1NR-9C C6/I5 (Tang Nano 9K proto dev board)
      .FCLKIN("27"),
      .IDIV_SEL(2), // -> PFD = 9 MHz (range: 3-400 MHz)
      .FBDIV_SEL(13), // -> CLKOUT = 126 MHz (range: 3.125-600 MHz)
      .ODIV_SEL(4) // -> VCO = 504 MHz (range: 400-1200 MHz)
    ) pll ( 
      .CLKOUTP(),
      .CLKOUTD(),
      .CLKOUTD3(),
      .RESET(1'b0),
      .RESET_P(1'b0),
      .CLKFB(1'b0),
      .FBDSEL(6'b0),
      .IDSEL(6'b0),
      .ODSEL(6'b0),
      .PSDA(4'b0),
      .DUTYDA(4'b0),
      .FDLY(4'b0),
      .CLKIN(CLK), // 27 MHz
      .CLKOUT(clk_100), // 126 MHz
      .LOCK(locked)
    );

    logic clk_25;
    CLKDIV #(
    .DIV_MODE(5)
    ) clkdiv_inst (
    .CALIB(1'b0),
    .CLKOUT(clk_25),
    .HCLKIN(clk_100),
    .RESETN(rst_n)
    );

    logic clk;
    logic rst_n;
    logic ena;
    logic [7:0] ui_in;
    logic [7:0] uio_in;
    logic [7:0] uo_out;
    logic [7:0] uio_out;
    logic [7:0] uio_oe;
    logic tmds_b;
    logic tmds_r;
    logic tmds_g;
    logic tmds_clk;
    
    `define GOWIN_FPGA
    heichips25_template heichips25_template (
        .ui_in  (ui_in),    // Dedicated inputs
        .uo_out (uo_out),   // Dedicated outputs
        .uio_in (uio_in),   // IOs: Input path
        .uio_out(uio_out),  // IOs: Output path
        .uio_oe (uio_oe),   // IOs: Enable path (active high: 0=input, 1=output)
        .ena    (clk_25),   // Gotta use DIV-5 IP thing...
        .clk    (clk),      // clock
        .rst_n  (rst_n),    // not reset
        .tmds_b (tmds_b),   // Blue
        .tmds_r (tmds_r),   // Red
        .tmds_g (tmds_g),   // Green
        .tmds_clk (tmds_clk)
    );
    
    mem_if mem_if(
        .clk(clk), 
        .rst_n(rst_n),
        .pixel(ui_in[7:4]),
        .bank(uio_out[1]),
        .addr({uio_out[0],uo_out}),
        .pix_sel(uio_out[4:2])
    );

    // Assignments
    assign ui_in[0] = 0;
    assign ui_in[1] = !BTN_N;
    assign ena = 1'b1;
    assign rst_n = RST_N && locked;
    assign clk = clk_100;
    
    // TMDS Encoder
    ELVDS_OBUF LVDS_TMDS_0 (  // Blue
      .I(tmds_b),
      .O(TMDS_D_P[0]),
      .OB(TMDS_D_N[0])
    );

    ELVDS_OBUF LVDS_TMDS_1 (  // Green
      .I(tmds_g),
      .O(TMDS_D_P[1]),
      .OB(TMDS_D_N[1])
    );

    ELVDS_OBUF LVDS_TMDS_2 (   // Red
      .I(tmds_r),
      .O(TMDS_D_P[2]),
      .OB(TMDS_D_N[2])
    );

    ELVDS_OBUF LVDS_TMDS_CLK (  // Clk
      .I(tmds_clk),
      .O(TMDS_CLK_P),
      .OB(TMDS_CLK_N)
    );
    
    // Inputs

    assign uio_in = '0;
    assign ui_in[3:2] = '0;

endmodule

