// TEROSHDL Documentation:
//! @title TMDS Serializer
//! @author Hossam Omar, Pascal G., Graeme Bragg [SystemVerilog refactor]
//! @version 1.0_sv
//! @date 01.09.2025
//! @brief Serializes the TMDS encoded data for HDMI output.
//!
//! SystemVerilog translation of a VHDL module to serialize the TMDS data 
//! and a pixel clock, ready to be passed over to the LVDS output driver.
//!
//! To reduce the overall clock needs, only a 5x clock is required - the way 
//! this module achives double-data-rate is by abusing a multiplexer with the
//! TMDS clock! It works on the Gowin Tang Nano 9k and RealDigital Boolean!
//! 

module tmds_serializer(
  input  serclk,
  input  rst,
  input  [9:0] tmds_parallel_r,
  input  [9:0] tmds_parallel_g,
  input  [9:0] tmds_parallel_b,
  output tmds_serial_r,
  output tmds_serial_g,
  output tmds_serial_b,
  output tmds_serial_c
);
  logic [9:0] shift_reg_r, shift_reg_g, shift_reg_b, shift_reg_c;
  logic [2:0] bit_cnt;

  always_ff @(posedge serclk) begin
    if(rst == 1) begin
      shift_reg_r <= '0;
      shift_reg_g <= '0;
      shift_reg_b <= '0;
      shift_reg_c <= '0;
      bit_cnt     <=  4;
    end else begin
      if (bit_cnt == 4) begin
        shift_reg_r <= tmds_parallel_r;
        shift_reg_g <= tmds_parallel_g;
        shift_reg_b <= tmds_parallel_b;
        shift_reg_c <= 10'b1111100000;
        bit_cnt   <= 0;
      end else begin
        shift_reg_r <= {2'b0, shift_reg_r[9:2]};
        shift_reg_g <= {2'b0, shift_reg_g[9:2]};
        shift_reg_b <= {2'b0, shift_reg_b[9:2]};
        shift_reg_c <= {2'b0, shift_reg_c[9:2]};
        bit_cnt   <= bit_cnt + 1;
      end
    end
  end

  assign tmds_serial_r = serclk ? shift_reg_r[0] : shift_reg_r[1];
  assign tmds_serial_g = serclk ? shift_reg_g[0] : shift_reg_g[1];
  assign tmds_serial_b = serclk ? shift_reg_b[0] : shift_reg_b[1];
  assign tmds_serial_c = serclk ? shift_reg_c[0] : shift_reg_c[1];
endmodule