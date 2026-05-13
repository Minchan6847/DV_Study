// 드라이버 클래스 - 테스트 데이터를 DUT로 전송
class Driver;

  // 가상 인터페이스를 통해 DUT와 연결
  virtual adder_if.tb_mp vif;

  // 생성기와 통신할 메일박스 선언
  mailbox #(bit [7:0]) gen2drv;

  // 생성자: 인터페이스와 메일박스 연결
  function new(virtual adder_if.tb_mp vif_handle, mailbox#(bit [7:0]) g2d);
    vif = vif_handle;
    gen2drv = g2d;
  endfunction

  // 실행 태스크: 데이터 입력 및 DUT 구동
  task run();
    bit [7:0] data;  // 테스트 데이터 (상위 4비트 = a, 하위 4비트 = b)
    $display("[%0t] Driver: Starting...", $time);

    forever begin
      // 클럭 하강 에지에 맞춰 동작
      @(negedge vif.clk);

      // 생성기에서 테스트 데이터 수신
      gen2drv.get(data);

      // 상위 4비트는 a, 하위 4비트는 b에 할당 (non-blocking 할당 사용)
      vif.a <= data[7:4];
      vif.b <= data[3:0];

      // 콘솔에 현재 입력 데이터 출력
      $display("[%0t] Driver: a=%0d, b=%0d inputting", $time, data[7:4], data[3:0]);
    end
  endtask

endclass
