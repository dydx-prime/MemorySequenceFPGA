// ECE 5440
// Author: Juan Aguilar, 1246
// button_shaper
// Generates a pulse for every button press
// Any comments and log

module button_shaper(
    input clk,
    input reset,
    input in,
    output reg out
);

parameter zero = 0, one = 1, two = 2;
reg [2:0] state, nextState;

always @(posedge clk)begin
    if (reset == 1'b0)
        state <= zero;
    else
        state <= nextState;
end

always @(state, in)begin
    case(state)
        zero: begin
            out = 1'b0;
            if(in == 1'b0)
                nextState = one;
            else
                nextState = zero;
        end

        one: begin
            out = 1'b1;
            nextState = two;
        end
        
        two: begin
	    out = 1'b0;
            if (in == 1'b1)
                nextState = zero;
            else
                nextState = two;
        end
        
        default: begin
            out = 1'b0;
            nextState = zero;
        end

    endcase
end
endmodule
