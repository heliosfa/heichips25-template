`timescale 1ns / 1ps
module color_lut (
  input logic [3:0] in_color,
  output logic [7:0] red_channel, green_channel, blue_channel
);
  always_comb begin
    case (in_color)
      4'b0000 : {red_channel, green_channel, blue_channel} = 24'h000000;  // BLACK
      4'b0001 : {red_channel, green_channel, blue_channel} = 24'hFF0000;  // Red
      4'b0010 : {red_channel, green_channel, blue_channel} = 24'hFF8000;  // Orange
      4'b0011 : {red_channel, green_channel, blue_channel} = 24'hFFBF00;  // Yellow-Orange
      4'b0100 : {red_channel, green_channel, blue_channel} = 24'hFFFF00;  // Yellow
      4'b0101 : {red_channel, green_channel, blue_channel} = 24'hBFFF00;  // Yellow-Green
      4'b0110 : {red_channel, green_channel, blue_channel} = 24'h80FF00;  // Green-Yellow
      4'b0111 : {red_channel, green_channel, blue_channel} = 24'h40FF00;  // Yellowish Green
      4'b1000 : {red_channel, green_channel, blue_channel} = 24'h00FF00;  // Green
      4'b1001 : {red_channel, green_channel, blue_channel} = 24'h00FF80;  // Green-Cyan
      4'b1010 : {red_channel, green_channel, blue_channel} = 24'h00FFBF;  // Cyan-Green
      4'b1011 : {red_channel, green_channel, blue_channel} = 24'h00FFFF;  // Cyan
      4'b1100 : {red_channel, green_channel, blue_channel} = 24'h0080FF;  // Blue-Cyan
      4'b1101 : {red_channel, green_channel, blue_channel} = 24'h0000FF;  // Blue
      4'b1110 : {red_channel, green_channel, blue_channel} = 24'h4B0082;  // Indigo
      4'b1111 : {red_channel, green_channel, blue_channel} = 24'h8F00FF;  // Violet
    endcase
  end
endmodule
