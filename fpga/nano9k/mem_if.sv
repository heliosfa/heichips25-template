// A very simple pixel-oriented read-only memory interface for reading from the HeiChips SRAM.
//
// Memory map:  Addr 0:383 = Frame A
//              Addr 512:895 = Frame B.
//              Addr 384:511, 896:1023 are unused.
//
// "bank" maps to sramAddr[9] and selects between Frame A and Frame B
// "addr" maps to sramAddr[8:0] and selects the word in memory
// "pixSel" selects the specific pixel in the word. Each word contains 8 4-bit pixels.
//
// "pixel" is the selected 4-bit pixel

module mem_if(
  input logic clk, rst_n,

  output logic [3:0] pixel,

  input logic bank,
  input logic [8:0] addr,
  input logic [2:0] pixSel
);

  logic [9:0] sramAddr;
  logic [31:0] sramDin, sramDout;
  logic sramWE, sramRD;

  SRAM SRAM (
    .clk(clk),
    .rst_n(rst_n),
    .DOUT(sramDout),
    .DIN(sramDin),
    .ADDR(sramAddr),
    .WE(sramWE),
    .RD(sramRD)
  );

  // Grab the specific pixel
  always_comb begin
    case(pixSel)
      3'b000  :   pixel = sramDout[3:0];
      3'b001  :   pixel = sramDout[7:4];
      3'b010  :   pixel = sramDout[11:8];
      3'b011  :   pixel = sramDout[15:12];
      3'b100  :   pixel = sramDout[19:16];
      3'b101  :   pixel = sramDout[23:20];
      3'b110  :   pixel = sramDout[27:24];
      3'b111  :   pixel = sramDout[31:28];
    endcase
  end

  // Simple address mapping
  assign sramAddr = {bank, addr};

  // Lock us into read operations.
  assign sramDin = '0;
  assign sramWE = 0;
  assign sramRD = 1;

endmodule