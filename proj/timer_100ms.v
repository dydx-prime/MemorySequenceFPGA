// ECE 5440
// Author: Juan Aguilar, 1246
// timer_100ms
// 100ms timer
// Any comments and log
module timer_100ms(clk, reset, enable, timeout_100ms);
    input clk, reset, enable;
    output timeout_100ms;

    wire timeout_1ms;
    timer_1ms t1(clk, reset, enable, timeout_1ms);
    counter100 c1(clk, reset, timeout_1ms, timeout_100ms);
endmodule
