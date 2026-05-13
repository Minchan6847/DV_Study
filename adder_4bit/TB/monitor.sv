// 모니터 클래스 - DUT 출력 신호 관찰
class Monitor;

  // 가상 인터페이스를 통해 DUT와 연결
  virtual adder_if.tb_mp vif;

  // 스코어보드와 통신할 메일박스 선언
  mailbox #(bit [12:0]) mon2scb;

  // 생성자: 인터페이스와 메일박스 연결
  function new(virtual adder_if.tb_mp vif_handle, mailbox#(bit [12:0]) m2s);
    vif = vif_handle;
    mon2scb = m2s;
  endfunction

  // 실행 태스크: DUT 출력 관찰 및 기록
  task run();
    // 관찰 결과 저장 (a 4비트 + b 4비트 + sum 5비트 = 13비트)
    bit [12:0] result;

    $display("[%0t] Monitor: Starting...", $time);

    forever begin
      // 클럭 상승 에지 대기
      @(posedge vif.clk);

      // 안정된 신호값 읽기 위한 약간의 지연
      #1;

      // a, b, sum 값을 하나의 패킷으로 결합
      result = {vif.a, vif.b, vif.sum};

      // 결과를 스코어보드로 전송
      mon2scb.put(result);

      // 콘솔에 관찰된 값 출력
      $display("[%0t] Monitor: a=%0d, b=%0d, sum=%0d observed", $time, vif.a, vif.b, vif.sum);
    end
  endtask

endclass
