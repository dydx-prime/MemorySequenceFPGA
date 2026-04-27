// ECE 5440
// Author: Juan Aguilar, 1246
// display_manager
// A partial control unit that displays the authentication arrangement vs the game arrangement
// Any comments and log
module display_manager(
	 input logged_in,
    input rng_on,
    input timer_on,
    input [6:0] player_input_decoded, 
    input [6:0] authenticationFSM_index,
    input [6:0] gamemode_index,
    input [6:0] timer_tenths,
    input [6:0] timer_ones,
    input [6:0] rng_values,


    output reg [6:0] hex5_display, // leftmost
    output reg [6:0] hex4_display,
    output reg [6:0] hex3_display,
    output reg [6:0] hex2_display,
    output reg [6:0] hex1_display,
    output reg [6:0] hex0_display // rightmost
);

    always@(*)begin
        if(timer_on) begin
            hex5_display = timer_tenths;
            hex4_display = timer_ones;
            hex3_display = 7'b111_1111;  
            hex2_display = player_input_decoded;
            hex1_display = 7'b111_1111;
            hex0_display = 7'b111_1111;
        end
        else if (rng_on) begin
            hex5_display = 7'b111_1111;
            hex4_display = 7'b111_1111;
            hex3_display = rng_values;  
            hex2_display = 7'b111_1111;
            hex1_display = 7'b111_1111;
            hex0_display = 7'b111_1111;
        end
        else if (logged_in) begin
            hex5_display = 7'b111_1111;
            hex4_display = 7'b111_1111;
            hex3_display = 7'b111_1111;  
            hex2_display = 7'b111_1111;
            hex1_display = 7'b111_1111;
            hex0_display = gamemode_index;
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
