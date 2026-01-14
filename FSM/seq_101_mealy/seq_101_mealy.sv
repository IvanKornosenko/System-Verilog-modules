//seq_101_mealy.sv
//Mealy FSM - детектор последовательности 101 (перекрывающийся)

//Создаем шапку
module seq_101_mealy (
    input logic clk,
    input logic rst,
    input logic d_in,
    output logic d_out
);
//Теперь кодирование
    typedef enum logic [1:0] {
        S_A = 2'b00,
        S_B = 2'b01,
        S_C = 2'b10
    } state_t;
    state_t state_reg, next_state;
//Комбинационная логика переходов
    always_comb begin
        next_state = state_reg; //это дефолтные значения
        d_out = 1'b0;           //это дефолтные значения

        unique case (state_reg)
            S_A: begin
                 next_state = d_in ? S_B : S_A;
                 d_out = 1'b0;
                 end
            S_B: begin
                 next_state = d_in ? S_B : S_C;
                 d_out = 1'b0;
                 end
            S_C: begin 
                 next_state = d_in ? S_B : S_A;
                 d_out = d_in; 
                 end
                endcase
                end
//Далее регистровый блок
    always_ff @(posedge clk)
        begin
            if(rst)
            state_reg <= S_A;
            else
            state_reg = next_state;
        end
endmodule

//В автомате Мили нам не нужно прописывать еще один comb блок для d_out, как это сделано в Мура. ПОТОМУ ЧТО d_out здесь прописываютя в самой логике state_reg

        

