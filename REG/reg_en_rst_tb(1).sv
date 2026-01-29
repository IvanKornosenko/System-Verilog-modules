`timescale 1ns/1ps

module reg_en_rst_tb;
//ОБЪЯВЛЕНИЕ СИГНАЛОВ
    localparam int WIDTH = 8;
    logic rst_n;
    logic clk;
    logic en;
    logic [WIDTH-1:0]d;
    logic[WIDTH-1:0]q;               //просто реальный q из DUT
    logic [WIDTH-1:0]expected_q;     //Ожидаемый q, этот сигнал будет потом в waveform, Checker будет выдавать ошибку, если не работает "ожидание - реальность"

// ИНСТАНЦИРОВАНИЕ DUT
    reg_en_rst #(
        .WIDTH(WIDTH)
    ) dut(
        .clk(clk),
        .rst_n(rst_n),
        .en(en),
        .d(d),
        .q(q)
    );
//ГЕНЕРАТОР CLK
    initial clk = 0;
    always #5 clk = ~clk;
//RESET SEQUENCE 
    initial
    begin
        rst_n = 0;                                      //Важная часть - сделать сброс для начала. Ибо без него мы не знаем состояние схемы, сброс дает точное знание о том, что на заданных входах "0"
        en = 0;
        d = '0;

        #20;
        rst_n = 1;                                      //убираем сброс
    end
//EXPCTED MODEL                                         //Та самая модель "ожиданий"
    always @(posedge clk or negedge rst_n)              //По сути это регистровый блок, который повторяет своим видом регистровый блог логики из DUT, только
                                                        //это новый always-блок со своей задачей
    if(!rst_n)                                      
        expected_q <= '0;                               //Здесь указано, что если сброс, то мы ОЖИДАЕМ увидеть на q --- ноль
    else if(en)
        expected_q <= d;                                //Иначе ожидаем увидеть на q --- d

//СТИМУЛЫ
    initial
    begin
        @(posedge rst_n);                               //Эта строка значит "после сброса"

        @(negedge clk);                                 //Важный момент. negedge здесь необходим, чтобы на waveform мы получили правильное отображение expecte_q и q.
                                                        //Эта проблема вызвана из-за того, что неблокирующее присваивание просто напросто не обновляет значение сразу
            en = 1;
            d = 8'h05;
        @(negedge clk);
            en = 0;
            d = 8'h09;
        @(negedge clk);
            en = 1;
            d = 8'h03;

    #20;
    $finish;
    end

//CHECKER                                               //Ну а это проверщик, который сравнивает q и expected_q и на основании этого делает вывод и в случае ошибки     
                                                        //на каком-то временном участке, выдает сообщениe
    always @(posedge clk)
    begin
        if(q !== expected_q)
        begin
            $error("MISMATCH! q=%h expected = %h", q, expected_q);
        end
    end
endmodule



       






