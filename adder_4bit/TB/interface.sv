// 인터페이스 모듈 - DUT와 테스트벤치를 연결하는 중간 통로
interface adder_if (
    input logic clk
);

  logic [3:0] a, b;  // 입력 신호
  logic [4:0] sum;  // 출력 신호

  // DUT 관점에서의 신호 방향 설정
  modport dut_mp(input a, b, clk, output sum);

  // 테스트벤치 관점에서의 신호 방향 설정
  modport tb_mp(output a, b, input clk, sum);

  // 편의를 위한 입력 설정 태스크
  task automatic set_inputs(logic [3:0] a_val, logic [3:0] b_val);
    a = a_val;
    b = b_val;
  endtask

  // 결과 검증 함수
  function automatic bit check_result();
    return (sum == a + b);
  endfunction

endinterface
