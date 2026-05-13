// 생성기 클래스 - 테스트 데이터 생성
class Generator;

  // 드라이버와 통신할 메일박스
  mailbox #(bit [7:0]) gen2drv;

  // 테스트 벡터 수량
  int num_vectors;

  // 생성자: 메일박스와 벡터 수량 설정
  function new(mailbox#(bit [7:0]) g2d, int vectors);
    gen2drv = g2d;
    num_vectors = vectors;
  endfunction

  // 실행 태스크: 테스트 데이터 생성
  task run();
    bit [7:0] data;

    $display("[%0t] Generator: %0d test vectors generation starting...", $time, num_vectors);

    for (int i = 0; i < num_vectors; i++) begin
      // 다양한 테스트 패턴 생성
      if (i < 5) begin
        // 패턴 1: a 증가, b 고정
        data = {i[3:0], 4'd5};
      end else if (i < 10) begin
        // 패턴 2: a 고정, b 증가
        data = {4'd10, i[3:0]};
      end else if (i < 15) begin
        // 패턴 3: 모두 같은 값
        data = {i[3:0], i[3:0]};
      end else begin
        // 패턴 4: 랜덤 값
        data[7:4] = $urandom_range(0, 15);
        data[3:0] = $urandom_range(0, 15);
      end

      // 생성된 데이터를 드라이버로 전송
      gen2drv.put(data);

      // 콘솔에 생성된 테스트 벡터 출력
      $display("[%0t] Generator: Vector generated a=%0d, b=%0d (Vector %0d/%0d)", $time, data[7:4],
               data[3:0], i + 1, num_vectors);

      // 생성 간격 (시뮬레이션 시간 단위)
      #5;
    end

    $display("[%0t] Generator: Vector generation completed", $time);
  endtask

endclass
