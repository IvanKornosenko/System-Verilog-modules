module counter_en_load #(
    parameter int WIDTH = 8
)(
    input  logic             clk,
    input  logic             rst_n,
    input  logic             en,
    input  logic             load,              //У load приоритет даже выше, чем у en
    input  logic [WIDTH-1:0] load_value,        //счетчик смотрит на load value, только тогда, когда load = 1
                                                //Это вход, потому что значениче может приходить откуда угодно, к примеру от FSM, от ЦП или от какого-либо другого блока
                                                
    output logic [WIDTH-1:0] count
);

    always_ff @(posedge clk or negedge rst_n) 
    begin
        if (!rst_n)
            count <= '0;
        else if (load)
            count <= load_value;
        else if (en)
            count <= count + 1'b1;
        else
            count <= count;                     //Это "держим" значение
    end

endmodule