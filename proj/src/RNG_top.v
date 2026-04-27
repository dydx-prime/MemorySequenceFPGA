module RNG_top(
    input clk,
    input reset,
    input RNG_on,
    input [3:0] RNG_count,
    input [3:0] RNG_speed,
    
    output reg RNG_done,
    output [3:0] RNG_val
);
    reg [3:0] gen_num_hold;
    wire [3:0] gen_num_out;

    reg [3:0] count;

    wire timer_pulse;
    LFSR_counter rng_val(
        .clk     (clk),
        .reset   (reset),
        //.pulse   (timer_pulse),
        .gen_num (gen_num_out) // output
    );

    custom_timer rngTimer(
        .clk(clk),
        .reset(reset),
        .enable(RNG_on),
        .count_val(RNG_speed),
        .timeout_1s(timer_pulse) // output; timeout based on count_val, count = 10 -> 1s
    );

    always @(posedge clk) begin
        if (!reset) begin
            gen_num_hold <= 4'd0;
            count <= 4'd0;
            RNG_done <= 1'b0;
        end
        else if (!RNG_on) begin
            gen_num_hold <= gen_num_out;
            count <= RNG_count;   // preload when off
            RNG_done <= 1'b0;
        end
        else begin
            if (!RNG_done && timer_pulse && count > 4'd0) begin
                gen_num_hold <= gen_num_out;
                count <= count - 4'd1;
                if (count == 4'd1)
                    RNG_done <= 1'b1;
            end
        end
    end

    assign RNG_val = gen_num_hold;

endmodule