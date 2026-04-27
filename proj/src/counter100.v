module counter100(clk, reset, one_ms_timeout, q);
    input clk, reset, one_ms_timeout;
    output q;
    reg q;

    reg [6:0] count;

    always@(posedge clk)begin
        if(reset == 1'b0) begin
            count <= 7'b0;
            q <= 1'b0;
        end

        else
            if(one_ms_timeout == 1'b1) begin
				if(count == 7'd99) begin // for synthesis
                //if(count == 7'd2) begin // for testing
                    q <= 1'b1;
                    count <= 7'b0;
                end
                else begin
                    count <= count + 7'b1;
                    q <= 1'b0;
                end
            end

            else
                q <= 1'b0;
    end
endmodule