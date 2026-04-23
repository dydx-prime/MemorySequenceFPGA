// ECE 5440
// Author: Juan Aguilar, 1246
// timer_1s
// 1s timer comprised of 100ms and counter 10
// Any comments and log
module timer_1s(clk, reset, enable, timeout_1s);
    input clk, reset, enable;
    output timeout_1s;

    wire timeout_100ms;
    timer_100ms t1(clk, reset, enable, timeout_100ms);
    counter10 c1(clk, reset, timeout_100ms, timeout_1s);
endmodule