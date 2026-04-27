module digitTimer_top(
    input clk,
    input reset,
    input timer_reconfig,   
    input timer_enable,
    input [3:0] d1_count,	
    input [3:0] d2_count,
    input [3:0] count_val,

    output timer_out,
    output [3:0]digit1_out,
    output [3:0]digit2_out
);  

    wire d1_request, d2_request;
    wire feedback_one;
    wire one_second_pulse;
    wire time_out_ones;

    //timer_1s(clk, reset, enable, timeout_1s);
    custom_timer sixty_sec(clk, reset, timer_enable, count_val, one_second_pulse);

    //tenths
    digitTimer d1(.clk(clk), .reset(reset), .pulse_in(d1_request),
                   .timer_reconfig(timer_reconfig), .feedback(1'b1),
		             .digit_timer_val(d1_count),
                   .pulse_out(d2_request), .time_out(feedback_one), .count(digit1_out));

    // ones
    digitTimer d2(.clk(clk), .reset(reset), .pulse_in(one_second_pulse),
                   .timer_reconfig(timer_reconfig), .feedback(feedback_one),
						 .digit_timer_val(d2_count),
                   .pulse_out(d1_request), .time_out(time_out_ones), .count(digit2_out));

    assign timer_out = feedback_one && time_out_ones;

endmodule