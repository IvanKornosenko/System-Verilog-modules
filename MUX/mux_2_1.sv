module mux_2_1 (
    input logic a,
    input logic b,
    input logic sel,
    output logic out
);
    assign out = sel ? b : a;
endmodule
