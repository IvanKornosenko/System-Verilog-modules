module simple_decoder (
    input logic [1:0] a,
    input logic en,
    output logic [3:0] y
);
    always_comb 
    begin
        if(en)
        begin
            case(a)
            2'b00: y = 4'b0001;
            2'b01: y = 4'b0010;
            2'b10: y = 4'b0100;
            2'b11: y = 4'b1000;
            endcase
        end
            else
            begin
                y = 4'b0000;
            end 
    end
endmodule
