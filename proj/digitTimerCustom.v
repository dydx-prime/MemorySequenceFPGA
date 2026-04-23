// ECE 5440
// Author: Juan Aguilar, 1246
// digitTimer9
// Singular 9-digit timer
// Any comments and log
module digitTimerCustom(
    input clk,
    input reset,
    input pulse_in,
    input timer_reconfig,
    input feedback,
    input [3:0]digit_value,
    output reg pulse_out,
    output reg time_out,
    output reg [3:0] count
);
    //reg [3:0] count;

    //feedback must be 0 to "borrow"
    always @(posedge clk) begin
        if(!reset || timer_reconfig) begin
            count <= digit_value;
            time_out <= 1'b0;
	        pulse_out <= 1'b0;
        end

        else begin
            pulse_out <= 1'b0;
	        time_out <= 1'b0;
	    
            if(count) begin
		        if (pulse_in)
                    count <= count - 1;
	        end
            
            else begin // !count
                if (feedback == 1'b0) begin
                    pulse_out <= 1;
                    count <= digit_value;
                end

                else
                    time_out <= 1;
            end

        end
    end

endmodule