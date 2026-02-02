//fsm_register 
//1)Объявляем сигналы
module fsm_reg #(
    parameter int WIDTH = 8
)(
    input logic clk,
    input logic rst_n,
    input logic en,
    input logic [WIDTH - 1:0] d,
    output logic [WIDTH - 1:0] q
);

//2)Объявляем состояния
typedef enum logic [1:0] {
    IDLE,
    LOAD,
    HOLD
} state_t;

state_t current_state, next_state;

//3)Регистр состояния. здесь никакой логики переходов, чисто память
always_ff @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        current_state <= IDLE;
    else
        current_state <= next_state;
end

//4) Логика переходов
    always_comb 
    begin
        next_state = current_state;     //Обязательно указать, по умолчанию, так как это защита от латчей

        case(current_state)
            IDLE: begin
                if(en)
                    next_state = LOAD;
            end

            LOAD: begin
                    next_state = HOLD;
            end

            HOLD: begin
                if(!en)
                    next_state = IDLE;
            end

            default: begin
                next_state = IDLE;
            end
        endcase
    end

//5)Логика выходов
    always_ff @(posedge clk or negedge rst_n) 
    begin
        if(!rst_n)
            q <= '0;
        else 
        begin
            case(current_state)     //Выход зависит только от состояния
                LOAD: q <= d;     //q обновляется только в LOAD
                default: q <= q; //удержание
            endcase
        end
    end
endmodule



            

