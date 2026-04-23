// ECE 5440
// Author: Juan Aguilar, 1246
// loadreg
// A d flip flop with a control signal used to gate player inputs
// Any comments and log
module loadreg (
    input clk,
    input reset,
    input load,
    input [3:0] d,
    output reg [3:0] q
);

    always @(posedge clk) begin
        if (reset == 1'b0)
            begin q <= 4'b0000; end
        else
            begin
                if (load == 1'b1)    
                    begin q <= d; end
            end
    end
    
endmodule