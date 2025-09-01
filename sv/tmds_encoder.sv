// TEROSHDL Documentation:
//! @title TMDS Encoder
//! @author Pascal G. (gfcwfzkm), Graeme Bragg (heliosfa) [SystemVerilog refactor]
//! @version 1.0_sv
//! @date 1.09.2025
//! @brief Encodes the color data into TMDS format for DVI/HDMI output.
//!
//! This is a SystemVerilog refactor of a VHDL module that encodes the color data 
//! into TMDS format, which is used for DVI and HDMI video outputs.It implements the
//! transition-minimizing encoding algorithm and DC balancing to ensure a balanced signal.
//! The control signals are also handled.
//! 
//! Make sure to use them only for the blue TMDS channel, as the
//! red and green channels carry other data when the display is not active. In this case, 
//! tie the hsync and vsync signals to '0' for the red and green channels.
//!
//! The TMDS encoding process is as follows:
//! ![DVI TMDS Video Data Encode Algorithm](https://fpga.mit.edu/6205/_static/F24/assignments/hdmi/tmds_tm/flowchart.png)
//!
//! Image from https://fpga.mit.edu/6205/F24/assignments/hdmi/tmds_tm, which is from the HDMI 1.3 specs.


module tmds_encoder(
  input  clk,
  input  reset,
  input  disp_enable,
  input  hsync,
  input  vsync,
  input  [7:0] color_data,
  output [9:0] tmds_encoded
);

  // Function to generate the TMDS control word during blanks
  function [9:0] tmds_ctrl;
    input hs;
    input vs;
    begin
      case ({vs, hs})
        2'b00: tmds_ctrl = 10'b1101010100;
        2'b01: tmds_ctrl = 10'b0010101011;
        2'b10: tmds_ctrl = 10'b0101010100;
        default: tmds_ctrl = 10'b1010101011;
      endcase
    end
  endfunction

  // Fucntion to count all the ones in an 8-bit value
  function logic [3:0] count_ones8 (input [7:0] s);
    logic [3:0] i;
    begin
      count_ones8 = '0;
      for (i = 0; i < 8; i = i + 1) begin
        count_ones8 = count_ones8 + {3'b0, s[i[2:0]]};
      end
    end
  endfunction


  // Declarations
  logic [9:0] tmds_output_reg, tmds_output_next;
  logic signed [4:0] dc_balancing_reg, dc_balancing_next;
  logic [8:0] tmds_intermediate;
  logic [7:0] xored_color_data, xnored_color_data;
  logic [3:0] ones_in_color_data, ones_in_tmds_inter, zeros_in_tmds_inter;
  logic use_xnor;
  

  // Output logic
  assign tmds_encoded = tmds_output_reg; 


  // Build XOR/XNOR chains as pure continuous logic because doing this in an always_comb 
  // falls into the "always_comb trap" (ALWCOMBORDER). 
  // Build xored_color_data and xnored_color_data from color_data with prefix XOR/XNOR,
  // matching the original VHDL behavior. This is circular combinatorial logic...
  logic [7:0] __xo_prefix, __xno_prefix;

  assign __xo_prefix[0]  = color_data[0];
  assign __xno_prefix[0] = color_data[0];

  genvar __i;
  generate
    for (__i = 1; __i < 8; __i++) begin : __gen_prefix
      assign __xo_prefix[__i]  = ~(__xo_prefix[__i-1] ^ color_data[__i]); // XNOR chain for xored
      assign __xno_prefix[__i] = __xno_prefix[__i-1] ^ color_data[__i]; // XOR chain for xnored
    end
  endgenerate

  assign xored_color_data  = __xo_prefix;
  assign xnored_color_data = __xno_prefix;
  assign ones_in_color_data = count_ones8(color_data);
  assign use_xnor = (ones_in_color_data > 4) || ((ones_in_color_data == 4) && (color_data[0] == '0));
  assign tmds_intermediate = use_xnor ? {1'b0, xored_color_data} : {1'b1, xnored_color_data};


  // TMDS word selection
  always_comb begin
    // defaults
    tmds_output_next  = '0;
    dc_balancing_next = '0; 

    // Count the ones and zeros in the intermediate data.
    ones_in_tmds_inter = count_ones8(tmds_intermediate[7:0]);
    zeros_in_tmds_inter = 8 - ones_in_tmds_inter;

    // Final select with blanking
    if (~disp_enable) begin 
      tmds_output_next  = tmds_ctrl(hsync, vsync);  // Calculate the control word for TMDS when blank
      dc_balancing_next = '0;                       // Reset balance

    end else if ((dc_balancing_reg == 5'sd0) || (ones_in_tmds_inter == 4)) begin
      // Check if the dc_balancing_reg is zero *or* if there are as many zeros as ones.
      // IF Cnt(t-1) == 0 OR N_1(tmds_inter[7:0]) == N_0(tmds_inter[7:0] THEN

      // First encode the final data depending if we used XNOR or XOR
      // tmds_out[9] = ~tmds_inter[8]
      // tmds_out[8] = tmds_inter[8]
      // tmds_out[7:0] = (tmds_inter[8] ? tmds_inter[7:0] : ~tmds_inter[7:0]

      // Track the amount of ones and zeros
      // IF tmds_intermediate(8) = '1' THEN
      //    Cnt(t) = Cnt(t-1) + N_1(tmds_inter[7:0]) - N_0(tmds_inter[7:0])
      // ELSE
      //    Cnt(t) = Cnt(t-1) - N_1(tmds_inter[7:0]) + N_0(tmds_inter[7:0])
      // END IF
      tmds_output_next  = tmds_intermediate[8] ? {~tmds_intermediate[8], tmds_intermediate} : {~tmds_intermediate[8], tmds_intermediate[8], ~tmds_intermediate[7:0]};
      dc_balancing_next = tmds_intermediate[8] ? (dc_balancing_reg + ones_in_tmds_inter - zeros_in_tmds_inter) : (dc_balancing_reg - ones_in_tmds_inter + zeros_in_tmds_inter);

    end else begin
      // We aren't in balance! Check if we have a lack or surplus of ones
      // and then invert the data based on this conclusion or not
      if (((dc_balancing_reg >  5'sd0) && (ones_in_tmds_inter > 4)) ||
          ((dc_balancing_reg <  5'sd0) && (ones_in_tmds_inter < 4))) begin
        // IF Cnt(t-1) > 0 AND N_1(tmds_inter[7:0]) > N_0(tmds_inter[7:0] OR
        //    Cnt(t-1) < 0 AND N_0(tmds_inter[7:0]) > N_1(tmds_inter[7:0] THEN

        // q_out[9] = 1
        // q_out[8] = tmds_inter[8]
        // q_out[7:0] = ~tmds_inter[7:0]
        tmds_output_next  = {1'b1, tmds_intermediate[8], ~tmds_intermediate[7:0]};
        // Track the amount of ones and zeros
        // Cnt(t) = Cnt(t-1) - 2*(~tmds_inter[8]) + N_1(tmds_inter[7:0]) - N_0(tmds_inter[7:0])
        dc_balancing_next = (dc_balancing_reg - ones_in_tmds_inter + zeros_in_tmds_inter) + (tmds_intermediate[8] ? 5'sd2 : 5'sd0);;
      end else begin
        // q_out[9] = 0
        // q_out[8] = tmds_inter[8]
        // q_out[7:0] = tmds_inter[7:0]
        tmds_output_next  = {1'b0, tmds_intermediate[8],  tmds_intermediate[7:0]};
        // Track the amount of ones and zeros
        // Cnt(t) = Cnt(t-1) + 2*(~tmds_inter[8]) + N_0(tmds_inter[7:0]) - N_1(tmds_inter[7:0])
        dc_balancing_next = (dc_balancing_reg + ones_in_tmds_inter - zeros_in_tmds_inter) - (!tmds_intermediate[8] ? 5'sd2 : 5'sd0);
      end
    end
  end


  // State update
  always_ff @(posedge clk) begin
    if (reset) begin
      tmds_output_reg  <= '0;
      dc_balancing_reg <= '0;
    end else begin
      tmds_output_reg  <= tmds_output_next;
      dc_balancing_reg <= dc_balancing_next;
    end
  end
endmodule
