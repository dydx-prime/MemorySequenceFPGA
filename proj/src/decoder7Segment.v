// ECE 5440
// Author: Juan Aguilar, 1246
// decoder7Segment
// Decodes the 4 bit input into a 7 bit output to drive the correct value to the display
// Any comments and log
module decoder7Segment (
    input [3:0] game_data_to_decode, 
    output reg [6:0] seven_segment_data
);

always@(game_data_to_decode)begin
    case (game_data_to_decode)
        4'h0:begin seven_segment_data = 7'b1000000; end
        4'h1:begin seven_segment_data = 7'b1111001; end
        4'h2:begin seven_segment_data = 7'b0100100; end
        4'h3:begin seven_segment_data = 7'b0110000; end
        4'h4:begin seven_segment_data = 7'b0011001; end
        4'h5:begin seven_segment_data = 7'b0010010; end
        4'h6:begin seven_segment_data = 7'b0000010; end
        4'h7:begin seven_segment_data = 7'b1111000; end
        4'h8:begin seven_segment_data = 7'b0000000; end
        4'h9:begin seven_segment_data = 7'b0011000; end
        4'hA:begin seven_segment_data = 7'b0100000; end
        4'hB:begin seven_segment_data = 7'b0000011; end
        4'hC:begin seven_segment_data = 7'b1000110; end
        4'hD:begin seven_segment_data = 7'b0100001; end
        4'hE:begin seven_segment_data = 7'b0000110; end
        4'hF:begin seven_segment_data = 7'b0001110; end
        default: begin seven_segment_data = 7'b0001001; end
    endcase
end

endmodule
