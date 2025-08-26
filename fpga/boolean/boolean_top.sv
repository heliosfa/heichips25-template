`timescale 1ns / 1ps

module boolean_top(
  output logic [15:0] led,
  input logic [15:0] sw,
  input logic [3:0] btn,
  input logic clk,
  
  output logic [2:0] hdmi_tx_n, hdmi_tx_p,
  output logic hdmi_clk_n, hdmi_clk_p
);

  logic clk_126, clk125_2;
  
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

  // Clock generation
  logic   locked;
  logic   clk_in_buf;
  logic   clk_126_unbuf, clk125_2_unbuf;

  logic [15:0] do_unused;
  logic clkfb, clkfb_buf;
  logic drdy_unused, psdone_unused;
  logic clkfboutb_unused;
  logic clkout0b_unused, clkout1b_unused;
  logic clkout2_unused, clkout2b_unused;
  logic clkout3_unused, clkout3b_unused;
  logic clkout4_unused, clkout5_unused;
  logic clkout6_unused;
  logic clkfbstopped_unused, clkinstopped_unused;

  IBUF clkin_ibufg
   (.O (clk_in_buf),
    .I (clk));

  MMCME2_ADV #(
    .BANDWIDTH            ("OPTIMIZED"),
    .CLKOUT4_CASCADE      ("FALSE"),
    .COMPENSATION         ("ZHOLD"),
    .STARTUP_WAIT         ("FALSE"),
    .DIVCLK_DIVIDE        (5),
    .CLKFBOUT_MULT_F      (31.500),
    .CLKFBOUT_PHASE       (0.000),
    .CLKFBOUT_USE_FINE_PS ("FALSE"),
    .CLKOUT0_DIVIDE_F     (5.000),
    .CLKOUT0_PHASE        (0.000),
    .CLKOUT0_DUTY_CYCLE   (0.500),
    .CLKOUT0_USE_FINE_PS  ("FALSE"),
    .CLKOUT1_DIVIDE       (25),
    .CLKOUT1_PHASE        (0.000),
    .CLKOUT1_DUTY_CYCLE   (0.500),
    .CLKOUT1_USE_FINE_PS  ("FALSE"),
    .CLKIN1_PERIOD        (10.000)
  ) mmcm_adv_inst (
    // Output clocks
    .CLKFBOUT            (clkfb),
    .CLKFBOUTB           (clkfboutb_unused),
    .CLKOUT0             (clk_126_unbuf),
    .CLKOUT0B            (clkout0b_unused),
    .CLKOUT1             (clk125_2_unbuf),
    .CLKOUT1B            (clkout1b_unused),
    .CLKOUT2             (clkout2_unused),
    .CLKOUT2B            (clkout2b_unused),
    .CLKOUT3             (clkout3_unused),
    .CLKOUT3B            (clkout3b_unused),
    .CLKOUT4             (clkout4_unused),
    .CLKOUT5             (clkout5_unused),
    .CLKOUT6             (clkout6_unused),
     // Input clock control
    .CLKFBIN             (clkfb_buf),
    .CLKIN1              (clk_in_buf),
    .CLKIN2              (1'b0),
     // Tied to always select the primary input clock
    .CLKINSEL            (1'b1),
    // Ports for dynamic reconfiguration
    .DADDR               (7'h0),
    .DCLK                (1'b0),
    .DEN                 (1'b0),
    .DI                  (16'h0),
    .DO                  (do_unused),
    .DRDY                (drdy_unused),
    .DWE                 (1'b0),
    // Ports for dynamic phase shift
    .PSCLK               (1'b0),
    .PSEN                (1'b0),
    .PSINCDEC            (1'b0),
    .PSDONE              (psdone_unused),
    // Other control and status signals
    .LOCKED              (locked),
    .CLKINSTOPPED        (clkinstopped_unused),
    .CLKFBSTOPPED        (clkfbstopped_unused),
    .PWRDWN              (1'b0),
    .RST                 (btn[0])
  );

  BUFG clkf_buf
   (.O (clkfb_buf),
    .I (clkfb));

  BUFG clkout1_buf
   (.O   (clk_126),
    .I   (clk_126_unbuf));

  BUFG clkout2_buf
   (.O   (clk125_2),
    .I   (clk125_2_unbuf));


  // The real meat
  heichips25_bagel heichips25_bagel (
    .ui_in  (ui_in),    // Dedicated inputs
    .uo_out (uo_out),   // Dedicated outputs
    .uio_in (uio_in),   // IOs: Input path
    .uio_out(uio_out),  // IOs: Output path
    .uio_oe (uio_oe),   // IOs: Enable path (active high: 0=input, 1=output)
    .ena    (ena),      // enable - goes high when design is selected
    .clk    (clk_126),  // clock
    .rst_n  (rst_n),    // not reset
    .tmds_b (tmds_b),   // Blue
    .tmds_r (tmds_r),   // Red
    .tmds_g (tmds_g),   // Green
    .tmds_clk (tmds_clk)
  );
  
  //assign led[15] = locked;
  assign rst_n = ~btn[0] && locked;
  assign ena = 1'b1;
  
  assign ui_in[0] = btn[1];
  assign ui_in[1] = sw[15];
  assign uio_in = '0;
  assign ui_in[3:2] = '0;


  logic [3:0] pixel_in;
  logic bank, mem_read, mem_row;
  logic [8:0] addr;
  logic [2:0] pix_sel;
  
  //assign led[15:4] = {addr,pix_sel};
  
  
  // LVDS Buffers
  OBUFDS #(.IOSTANDARD("DEFAULT"), .SLEW("SLOW")) LVDS_TMDS_0 (
    .I(tmds_b),
    .O(hdmi_tx_p[0]),
    .OB(hdmi_tx_n[0])
  );
  
  OBUFDS #(.IOSTANDARD("DEFAULT"), .SLEW("SLOW")) LVDS_TMDS_1 (
    .I(tmds_g),
    .O(hdmi_tx_p[1]),
    .OB(hdmi_tx_n[1])
  );
  
  OBUFDS #(.IOSTANDARD("DEFAULT"), .SLEW("SLOW")) LVDS_TMDS_2 (
    .I(tmds_r),
    .O(hdmi_tx_p[2]),
    .OB(hdmi_tx_n[2])
  );
  
  OBUFDS #(.IOSTANDARD("DEFAULT"), .SLEW("SLOW")) LVDS_TMDS_CLK (
    .I(tmds_clk),
    .O(hdmi_clk_p),
    .OB(hdmi_clk_n)
  );

  
  mem_if mem_if(
    .clk(clk_126), 
    .rst_n(rst_n),
    .pixel(ui_in[7:4]),
    .bank(uio_out[1]),
    .addr({uio_out[0],uo_out}),
    .pix_sel(uio_out[4:2])
  );

endmodule
