module priority_encoder_4to2 (
    input logic [3:0] in,
    output logic [1:0] out,
    output logic valid
);
    always_comb 
    begin
        priority case (in)
        4'b0001 : out = 2'b00;
        4'b001x : out = 2'b01;
        4'b01xx : out = 2'b10;
        4'b1xxx : out = 2'b11;
        default : out = 2'bxx;
        endcase
    end
    assign valid = | in;
endmodule
