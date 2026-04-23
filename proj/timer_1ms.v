// ECE 5440
// Author: Juan Aguilar, 1246
// timer_1ms
// 1ms timer - LFSR Implementation
// Any comments and log
module timer_1ms(clk, reset, enable, one_ms_timeout);
    input clk, reset, enable;
    output one_ms_timeout;
    reg one_ms_timeout;

    reg [15:0] LFSR;
    wire feedback = LFSR[15];

    always@(posedge clk)begin
        if(!reset) begin
            LFSR <= 16'hFFFF;
            one_ms_timeout <= 1'b0;
        end

        else begin // main logic
            if(enable) begin
                if(LFSR == 16'h6DB6) begin
                    LFSR <= 16'hFFFF;
                    one_ms_timeout <= 1'b1;               
                end

                else begin
                    LFSR[0] <= feedback;
                    LFSR[1] <= LFSR[0];
                    LFSR[2] <= LFSR[1] ^ feedback;
                    LFSR[3] <= LFSR[2] ^ feedback;
                    LFSR[4] <= LFSR[3];
                    LFSR[5] <= LFSR[4] ^ feedback;
                    LFSR[6] <= LFSR[5];
                    LFSR[7] <= LFSR[6];
                    LFSR[8] <= LFSR[7];
                    LFSR[9] <= LFSR[8];
                    LFSR[10] <= LFSR[9];
                    LFSR[11] <= LFSR[10];
                    LFSR[12] <= LFSR[11];
                    LFSR[13] <= LFSR[12];
                    LFSR[14] <= LFSR[13];
                    LFSR[15] <= LFSR[14];
                    one_ms_timeout <= 1'b0;
                end
            end
            else
                one_ms_timeout <= 1'b0;
        end
    end

endmodule