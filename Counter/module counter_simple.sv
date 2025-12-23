module counter_simple #(
    parameter int WIDTH = 8
)(
    input logic clk,
    input logic rst_n,
    output logic [WIDTH - 1:0] count
);
    always_ff @(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
        count <= '0;                 //'0. Апостроф в данном случае означает, что нет привязки к ширине
    else
        count <= count + 1'b1;
    end
endmodule
