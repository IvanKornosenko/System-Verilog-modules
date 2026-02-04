//testbench for fsm_reg
`timescale 1ns/1ps;

module fsm_reg_tb;
    localparam int WIDTH = 8;   
    logic clk;
    logic rst_n;
    logic en;
    logic [WIDTH-1:0] d;
    logic [WIDTH-1:0] q;
    logic [WIDTH-1:0] q_prev;
//ИНСТАНС dut
    fsm_reg #(
        .WIDTH(WIDTH)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .en(en),
        .d(d),
        .q(q)
    );
//CLK

    initial clk = 0;
    always #5 clk = ~clk;
//RESET

    initial 
    begin
        rst_n = 0;
        en = 0;
        d = '0;

        #20;
        rst_n = 1;

    end
//СТИМУЛЫ (главное помнить, что все входы меняем на negedge clk)
    //Сценарий 1 - Reset → IDLE
    initial 
    begin
        @(posedge rst_n);   // IDLE: en=0, q должен удерживаться
        @(negedge clk);     //en=0; d=8'hAA;

    //Сценарий 2 - IDLE → LOAD → HOLD
    //запускаем загрузку

    @(negedge clk);
        en = 1;
        d = 8'h55;
    //en все еще 1, значит должно быть удержание
    @(negedge clk);
        en = 1;
        d = 8'hFF;
    //Сценарий 3 HOLD → IDLE
    @(negedge clk);
        en = 0;
    
    //Завершение 
    #20 $finish;

    end
//CHECKER (здесь надо написать упрощенный FSM, чтобы не дублировать его целиком)
//Checker №1 (q не меняется вне load)
  
    always @(posedge clk or negedge rst_n) 
    begin
        if(!rst_n)
            q_prev <= '0;
        else
            q_prev <= q;
    end

    always @(posedge clk) 
    begin
        if(!rst_n) 
        begin
        //во время сброса ничего не проверяем
        end
        else if(q !== q_prev)
        begin
        if(!en)
            $error("q changed outside LOAD-like condition");
        end
    end
//Checker №2 (сброс очищает q)
    always @(posedge rst_n) 
    begin
    #1;
    if(q !== '0)
        $error("q not reset correctly");
    end
endmodule




