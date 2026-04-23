// ECE 5440
// Author: Juan Aguilar, 1246
// rng
// Random Number Generator
// Any comments and log
module rng(
    input clk,
    input reset,
    input rng_gen,
    output [3:0] random_num
    );

    wire count = ~rng_gen; 
    wire [3:0] rng_out;
    reg [3:0] rng_hold;

    LFSR_counter ins1(clk, reset, rng_out);

    always @(posedge clk) begin
        if(!reset)
            rng_hold <= 4'b0;
        else begin
            if(count)
                rng_hold <= rng_out;
        end
    end


    assign random_num = rng_hold;
endmodule