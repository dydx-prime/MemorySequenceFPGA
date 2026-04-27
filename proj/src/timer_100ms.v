module timer_100ms(
    input clk, 
    input reset, 
    input enable,
    output timeout_100ms
);
    wire timeout_1ms;
    timer_1ms t1(clk, reset, enable, timeout_1ms);
    //counter100 t1(clk, reset, enable, timeout_1ms); // simulation
    counter100 c1(clk, reset, timeout_1ms ,timeout_100ms); // count of 100
endmodule
