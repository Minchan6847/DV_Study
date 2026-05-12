// 스코어보드 클래스 - 테스트 결과 검증
class Scoreboard;

  // 모니터와 통신할 메일박스
  mailbox #(bit [12:0]) mon2scb;

  // 결과 통계
  int passed, failed;

  // 생성자: 메일박스 연결 및 카운터 초기화
  function new(mailbox#(bit [12:0]) m2s);
    mon2scb = m2s;
    passed  = 0;
    failed  = 0;
  endfunction

  // 실행 태스크: 결과 분석 및 검증
  task run();
    bit [12:0] result;  // 모니터에서 받은 결과
    bit [3:0] a, b;  // 입력값 분리 저장
    bit [4:0] sum, expected_sum;  // 실제 출력값과 예상 출력값

    $display("[%0t] Scoreboard: Starting...", $time);

    forever begin
      // 모니터에서 결과 수신
      mon2scb.get(result);

      // 결과 패킷에서 a, b, sum 추출
      a = result[12:9];
      b = result[8:5];
      sum = result[4:0];

      // 예상 결과 계산 (정답)
      expected_sum = a + b;

      // 실제 출력과 예상 출력 비교
      if (sum === expected_sum) begin
        $display("[%0t] Scoreboard: Passed! a=%0d + b=%0d = %0d", $time, a, b, sum);
        passed++;
      end else begin
        $display("[%0t] Scoreboard: Failed! a=%0d + b=%0d, output=%0d expected=%0d", $time, a, b,
                 sum, expected_sum);
        failed++;
      end
    end
  endtask

  // 최종 테스트 결과 보고
  function void report();
    $display("\n----- Test Results Report -----");
    $display("Total tests: %0d", passed + failed);
    $display("Passed: %0d", passed);
    $display("Failed: %0d", failed);

    if (failed == 0) $display("All tests passed! O");
    else $display("Some tests failed! X Please check the results.");

    $display("---------------------------\n");
  endfunction

endclass
