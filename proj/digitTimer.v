// ECE 5440
// Author: Juan Aguilar, 1246
// digitTimer
// 99 Digit Timer with 1 second input pulse
// Any comments and log
module digitTimer(
    input clk,
    input reset,
    input timer_reconfig,   
    input timer_enable,
    input [3:0] digit1_time,
    input [3:0] digit2_time,
    output timer_out,
    output [3:0]digit1_out,
    output [3:0]digit2_out
);  

    wire d1_request, d2_request;
    wire feedback_one;
    wire one_second_pulse;

    //timer_1s(clk, reset, enable, timeout_1s);
    timer_1s sixty_sec(clk, reset, timer_enable, one_second_pulse);

    digitTimerCustom d1(.clk(clk), .reset(reset), .pulse_in(d1_request),
                   .timer_reconfig(timer_reconfig), .feedback(1'b1),
                   .pulse_out(d2_request), .time_out(feedback_one), .count(digit1_out));

    digitTimerCustom d2(.clk(clk), .reset(reset), .pulse_in(one_second_pulse),
                   .timer_reconfig(timer_reconfig), .feedback(feedback_one),
                   .pulse_out(d1_request), .time_out(timer_out), .count(digit2_out));

endmodule