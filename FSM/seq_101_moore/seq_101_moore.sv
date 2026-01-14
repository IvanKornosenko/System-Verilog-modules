//seq_101_moore.sv
//Moore FSM - детектор последовательности 101 (перекрывающийся)

//Создаем шапку
module seq_101_moore (
    input logic clk,
    input logic rst,
    input logic d_in,
    output logic d_out
);
//Далее нужно произвести кодировку состояний
    typedef enum logic [1:0] {              
        S_A = 2'd0,             //Это и есть наше состояние "A" - ничего полезного
        S_B = 2'd1,             //Состояние "B". "1"
        S_C = 2'd2,             //Состояние "C". "10"    
        S_D = 2'd3              //Состояние "D". "101" (d_out = 1)
    } state_t;
    state_t state_reg, state_next;

//Теперь нужно настроить комбинационную логику переходов (state_next)

    always_comb
        begin
        state_next = state_reg;

        unique case(state_reg)
            S_A: begin
                 if(d_in == 1'b0) state_next = S_A;     //Это как по таблице переходов, Если пришел 0, то "А" остается "А"
                 else state_next = S_B;                //(d_in == 1'b1) - тогда совершится переход в "B"
                 end
            S_B: begin
                 if(d_in == 1'b0) state_next = S_C;     
                 else state_next = S_B;
                 end
            S_C: begin
                 if(d_in == 1'b0) state_next = S_A;
                 else state_next = S_D;
                 end
            S_D: begin
                 if(d_in == 1'b0) state_next = S_C;
                 else state_next = S_B;
                 end
            default: state_next = S_A;                  //Нужно задать дефолтное значение, при котором у нас "A"

                endcase
        end
    
//Следующий шаг - описать работу регистра. Сброс синхронный

    always_ff @(posedge clk)
        begin
        if(rst)
            state_reg <= S_A;                           //мы сбрасываем state_reg       
        else
            state_reg <= state_next;
        end
//Следующий шаг - описать логику выхода. Здесь используется комбинационка. Т.к. автомат Мура, то выход зависит только от (state_reg)

    always_comb 
        begin
            d_out = (state_reg == S_D) ? 1'b1 : 1'b0;
        end
endmodule




    



             



