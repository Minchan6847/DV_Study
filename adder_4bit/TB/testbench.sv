`include "interface.sv"
`include "driver.sv"
`include "monitor.sv"
`include "generator.sv"
`include "scoreboard.sv"

// 테스트벤치 최상위 모듈
module tb_top;
  // 시뮬레이션 시간 단위 설정
  timeunit 1ns; timeprecision 1ps;

  // 클럭 신호 선언
  logic clk;

  // 인터페이스 인스턴스 생성 (클럭 연결)
  adder_if aif (clk);

  // DUT(Design Under Test) 인스턴스 생성
  adder_4bit dut (
      .clk(clk),
      .a  (aif.a),
      .b  (aif.b),
      .sum(aif.sum)
  );

  // 컴포넌트 간 통신 메일박스 생성
  mailbox #(bit [7:0]) gen2drv = new();  // 생성기 → 드라이버
  mailbox #(bit [12:0]) mon2scb = new();  // 모니터 → 스코어보드

  // 테스트 컴포넌트 인스턴스 생성
  Generator gen = new(gen2drv, 20);  // 20개 테스트 벡터 생성
  Driver drv = new(aif, gen2drv);  // 드라이버에 인터페이스 연결
  Monitor mon = new(aif, mon2scb);  // 모니터에 인터페이스 연결
  Scoreboard scb = new(mon2scb);  // 스코어보드 생성

  // 클럭 생성 (10ns 주기)
  initial begin
    clk = 0;
    forever #5 clk = ~clk;  // 5ns마다 반전 = 10ns 주기
  end

  // 테스트 실행 및 제어
  initial begin
    $display("\n===== Testbench Starting =====\n");

    // 모든 컴포넌트를 병렬로 실행
    fork
      gen.run();  // 생성기 실행
      drv.run();  // 드라이버 실행
      mon.run();  // 모니터 실행
      scb.run();  // 스코어보드 실행
    join_any  // 하나라도 완료되면 진행

    // 생성기가 완료된 후 남은 테스트가 처리될 시간
    #50;

    // 최종 테스트 결과 보고서 출력
    scb.report();

    $display("\n===== Testbench Completed =====\n");
    $finish;  // 시뮬레이션 종료
  end

  // 파형 덤프 설정 (시뮬레이션 후 파형 확인용)
  initial begin
    $dumpfile("adder_tb.vcd");
    $dumpvars(0, tb_top);
  end

endmodule
