//testbench reg_en_rst
timescale 1ns/1ps
module reg_en_rst_tb;
//ОБЪЯВЛЕНИЕ СИГНАЛОВ
    localparam int WIDTH = 8;
    logic clk,
    logic rst_n,
    logic en,
    logic [WIDTH-1:0]d;
    logic [WIDTH-1:0]q;
//ИНСТАНЦИРОВАНИЕ DUT
    reg_en_rst #(
        .WIDTH(WIDTH)
    ) dut (
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
        rst_n = 0;
        en = 0;
        d = '0;

        #20;
        rst_n = 1;
    end
//EXPECTED MODEL
    logic [WIDTH - 1:0] expexted_q;

    always_ff @(posedge clk or negedge rst_n)
        if(!rst_n)
            expected_q <= '0;
        else if(en)
            expected_q <= d;
 //СТИМУЛЫ
    initial 
    begin
        @(posedge rst_n);                       //после сброса

        repeat (5)                              //повторяем 5 раз
        begin
            @(posedge clk);
            en = $urandom_range(0,1);           //enable прыгает
            d = $urandom;                       //рандомные данные
        end

        #20;
        $finish;
    end

    //СHECKER (это самая важная часть)
    always @(posedge clk) 
    begin
        if(q !== expected_q) 
        begin
            $error("mismatch! q=%h expected=%h", q, expected_q);
        end
    end
endmodule



