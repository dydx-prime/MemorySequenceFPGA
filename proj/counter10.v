// ECE 5440
// Author: Juan Aguilar, 1246
// counter10
// 4-Bit counter, count up to 10
// Any comments and log
module counter10(clk, reset, hundred_ms_timeout, q);
    input clk, reset, hundred_ms_timeout;
    output q;
    reg q;

    reg [3:0] count;

    always@(posedge clk)begin
        if(reset == 1'b0) begin
            count <= 4'b0;
            q <= 1'b0;
        end

        else 
            if(hundred_ms_timeout == 1'b1)begin
					 if(count == 4'd9) begin //for synthesis
                //if(count == 4'd1) begin // for testing
                    q <= 1'b1;
                    count <= 4'b0;
                end
                else begin
                    count <= count + 1;
                    q <= 1'b0;
                end
            end
            else
                q <= 1'b0;
    end
endmodule
