module mux 4_1 (
    input logic [3:0] in,
    input logic [1:0] sel,
    output logic out
);

    always_comb
    begin
        case(sel)
        2'b00 = in[0];
        2'b01 = in[1];
        2'b10 = in[2];
        2'b11 = in[3];
        endcase
    end
endmodule
