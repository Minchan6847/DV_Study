// 4비트 덧셈기 - DUT(Design Under Test)
module adder_4bit (
    input logic clk,
    input logic [3:0] a,
    b,
    output logic [4:0] sum
);

  always_ff @(posedge clk) begin
    sum <= a + b;  // 4비트 + 4비트 = 최대 5비트
  end

endmodule
