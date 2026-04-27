module custom_timer(
    input clk, 
    input reset, 
    input enable,
    input [3:0] count_val,
    output timeout_1s
);

    wire timeout_100ms;
    timer_100ms t1(clk, reset, enable, timeout_100ms);
    counter_mod c1(clk, reset, timeout_100ms, count_val, timeout_1s); // responsible for actual timer speed

endmodule