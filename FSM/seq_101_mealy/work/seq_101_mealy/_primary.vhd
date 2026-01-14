library verilog;
use verilog.vl_types.all;
entity seq_101_mealy is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        d_in            : in     vl_logic;
        d_out           : out    vl_logic
    );
end seq_101_mealy;
