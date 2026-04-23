// ECE 5440
// Author: Juan Aguilar, 1246
// display_manager
// A partial control unit that displays the authentication arrangement vs the game arrangement
// Any comments and log
module display_manager(
    input logged_in,
    input [6:0] player_input_decoded, 
    input [6:0] authenticationFSM_index,

    output reg [6:0] hex5_display, // leftmost
    output reg [6:0] hex4_display,
    output reg [6:0] hex3_display,
    output reg [6:0] hex2_display,
    output reg [6:0] hex1_display,
    output reg [6:0] hex0_display // rightmost
);

    always@(*)begin
        if(logged_in) begin
            hex5_display = 7'b111_1111;
            hex4_display = 7'b111_1111;
            hex3_display = 7'b111_1111;  
            hex2_display = player_input_decoded;
            hex1_display = 7'b111_1111;
            hex0_display = 7'b111_1111;
        end
        else begin
            hex5_display = 7'b111_1111;
            hex4_display = 7'b111_1111;
            hex3_display = 7'b111_1111;  
            hex2_display = authenticationFSM_index;
            hex1_display = 7'b111_1111;
            hex0_display = 7'b111_1111;
        end
    end

endmodule
