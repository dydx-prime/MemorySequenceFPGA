module digitTimer(
    input clk,
    input reset,
    input pulse_in,
    input timer_reconfig,
    input feedback,
    input [3:0] digit_timer_val,
    output reg pulse_out,
    output reg time_out,
    output reg [3:0] count
);
    //reg [3:0] count;
    reg zero_out;

    //feedback must be 0 to "borrow"
    always @(posedge clk) begin
        if(!reset || timer_reconfig) begin
            count <= digit_timer_val;
            time_out <= 1'b0;
	    pulse_out <= 1'b0;
	    zero_out <= 1'b1;
        end

        else begin
	    zero_out <= 1'b1;
	    pulse_out <= 1'b0;
	    time_out <= 1'b0;
            if(count) begin
		if (pulse_in)
                    count <= count - 1;
	    end
            
            else begin // !count
                if (feedback == 1'b0 && pulse_in) begin
                    pulse_out <= 1;
                    count <= 4'd9;
                end
		else
                    time_out <= 1'b1;

            end

        end
    end

endmodule