//seq_1011_moore

module seq_1011_moore(
    input logic clk,
    input logic rst,
    input logic d_in,
    output logic d_out
);
    typedef enum logic [2:0] {              //Здесь добавляется еще один бит для кодирования
        S_A = 3'd0,            
        S_B = 3'd1,             
        S_C = 3'd2,                
        S_D = 3'd3,  
        S_E = 3'd4
    }state_t;
    state_t state_reg, state_next;

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
                 else state_next = S_E;
                 end
            S_E: begin
                 if(d_in == 1'b0) state_next = S_C; //В детекторе 1011 у нас просто добавляется новое состояние "E"
                 else state_next = S_B;
                 end
            default: state_next = S_A;                  //Нужно задать дефолтное значение, при котором у нас "A"

                endcase
        end
    
    always_ff @(posedge clk)
    begin 
        if(rst)
        state_reg <= S_A;
    else
        state_reg <= state_next;
    end

    always_comb
    begin
        d_out = (state_reg == S_E) ? 1'b1 : 1'b0;
    end
endmodule

