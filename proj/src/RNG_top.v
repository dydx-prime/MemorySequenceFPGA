module RNG_top(
    input clk,
    input reset,
	 input game_reset,
    input RNG_on,
    input [3:0] RNG_count,
    input [3:0] RNG_speed,

    //fifo signal
    output reg wr_en,
    
    output reg RNG_done,
    output [3:0] RNG_val
);
    reg [3:0] gen_num_hold;
    wire [3:0] gen_num_out;
    

    reg [3:0] count;
    reg init_bit; 

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
        if (!reset || game_reset) begin
            gen_num_hold <= 4'b0;
            count <= 4'b0;
            RNG_done <= 1'b0;
            wr_en <= 1'b0;
            init_bit <= 1'b1;
        end
        else if (!RNG_on) begin // when not active
            //gen_num_hold <= gen_num_out;
            count <= RNG_count;   // preload when off
            RNG_done <= 1'b0;
            wr_en <= 1'b0;
            init_bit <= 1'b1;
        end
        else begin
            wr_en <= 1'b0;

            if(init_bit) begin // force first value into the fifo, or else it gets skipped
                gen_num_hold <= gen_num_out;
					 init_bit <= 1'b0;
					 wr_en <= 1'b1;
            end
		      // continue for the other values
            else if (!RNG_done && timer_pulse && count > 4'b0 && (gen_num_hold != gen_num_out)) begin
                gen_num_hold <= gen_num_out;

                if(count == 4'b1) begin
                    RNG_done <= 1'b1;
                    wr_en <= 1'b1;
                end

                else begin
                    wr_en <= 1'b1;
                    count <= count - 4'b1;
                end
            end
        end
    end

    assign RNG_val = gen_num_hold;

endmodule