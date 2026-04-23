// ECE 5440
// Author: Juan Aguilar, 1246
// LFSR_counter
// Random Number Generator - LFSR Implementation
// Any comments and log
module LFSR_counter(
    input clock,
    input reset,
    output [3:0] gen_num
    );

  reg [15:0] LFSR;
  wire feedback = LFSR[15];

  always @(posedge clock) begin
    if(!reset)
        LFSR <= 16'h5F00;
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
    end
  end

  assign gen_num = {LFSR[15], LFSR[10], LFSR[5], LFSR[1]};


endmodule
