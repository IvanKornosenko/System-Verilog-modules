module decoder 2_to_4 (
    input logic [1:0] a,
    input logic en,
    output logic [3:0]
);
    always_comb 
    begin
        y = en ? (1 << a) : 4b'0      //побитовый сдвиг удобнее, чем case, тем более в более массивных декодерах
    end
endmodule
