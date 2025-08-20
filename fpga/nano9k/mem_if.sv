// A very simple pixel-oriented read-only memory interface for reading from the HeiChips SRAM.
//
// Memory map:  Addr 0:383 = Frame A
//              Addr 512:895 = Frame B.
//              Addr 384:511, 896:1023 are unused.
//
// "bank" maps to sram_addr[9] and selects between Frame A and Frame B
// "addr" maps to sram_addr[8:0] and selects the word in memory
// "pix_sel" selects the specific pixel in the word. Each word contains 8 4-bit pixels.
//
// "pixel" is the selected 4-bit pixel

module mem_if(
  input logic clk, rst_n,

  output logic [3:0] pixel,

  input logic bank,
  input logic [8:0] addr,
  input logic [2:0] pix_sel
);

  logic [9:0] sram_addr;
  logic [31:0] sram_din, sram_dout;
  logic sram_we, sram_rd;

  SRAM SRAM (
    .clk(clk),
    .rst_n(rst_n),
    .DOUT(sram_dout),
    .DIN(sram_din),
    .ADDR(sram_addr),
    .WE(sram_we),
    .RD(sram_rd)
  );

  // Grab the specific pixel
  always_comb begin
    case(pix_sel)
      3'b000  :   pixel = sram_dout[3:0];
      3'b001  :   pixel = sram_dout[7:4];
      3'b010  :   pixel = sram_dout[11:8];
      3'b011  :   pixel = sram_dout[15:12];
      3'b100  :   pixel = sram_dout[19:16];
      3'b101  :   pixel = sram_dout[23:20];
      3'b110  :   pixel = sram_dout[27:24];
      3'b111  :   pixel = sram_dout[31:28];
    endcase
  end

  // Simple address mapping
  assign sram_addr = {bank, addr};

  // Lock us into read operations.
  assign sram_din = '0;
  assign sram_we = 0;
  assign sram_rd = 1;

endmodule