module divide_5(
  input logic clk, rst_n,
  output clk_out
);

  logic d2,d1,d0;
  logic q2,q1,q0,q2temp;
  
  assign d0 = ~q2 & ~q0;
  assign d1 = (q1&~q0) | (~q1 & q0);
  assign d2 = q1 & q0;

  //q0
  always_ff @(posedge clk) begin
    if(!rst_n) begin
      q0 <= 0;
      q1 <= 0;
      q2 <= 0;
    end else begin
      q0 <= d0;
      q1 <= d1;
      q2 <= d2;
    end
  end

  always_ff @(negedge clk) begin
    q2temp <= q1;
  end
  
  assign clk_out = q1 | q2temp;
endmodule
