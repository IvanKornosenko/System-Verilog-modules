library verilog;
use verilog.vl_types.all;
entity traffic_light is
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        red             : out    vl_logic;
        yellow          : out    vl_logic;
        green           : out    vl_logic
    );
end traffic_light;
