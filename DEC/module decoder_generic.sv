module decoder_generic #(parameter int WIDTH = 3)
(
    input logic [WIDTH-1:0] a,
    input logic en,
    output logic [(1 << WIDTH)-1:0] y // ширина выхода автоматически 
);
    always_comb
    begin
        if(en)
        y = 1 << a;
        else
        y = '0;                 //'0 = все биты нулём (очень полезно в SV)
    end
endmodule


