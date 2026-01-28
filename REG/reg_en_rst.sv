module reg_en_rst #(
    parameter WIDTH = 8
)(
    input logic rst_n,
    input logic clk,
    input logic en,
    input logic [WIDTH - 1:0] d,
    output logic [WIDTH - 1:0]q
);
    always_ff @(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
        begin
            q <= '0;
        end
            else if(en)
            begin
                q <= d;
            end
    end
endmodule

