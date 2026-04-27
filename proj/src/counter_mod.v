module counter_mod(
    input clk,
    input reset,
    input hundred_ms_timeout,
    input [3:0] count_val,
    output reg q
);

    reg [3:0] count;

    always@(posedge clk)begin
        if(!reset) begin
            count <= 4'b0;
            q <= 1'b0;
        end

        else begin
            if(hundred_ms_timeout == 1'b1)begin
                if(count == count_val)begin
                    q <= 1'b1;
                    count <= 4'b0;
                end

                else begin
                    count <= count + 4'b1;
                    q <= 1'b0;
                end
            end

            else
                q <= 1'b0;
        end
    end

endmodule