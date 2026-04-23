module game_setup(
    input clk,
    input reset,
    input PSWD_match,
    input modeSel_btn,
    input startGame_btn, // also acts as player load
    input auth_btn,

    output reg logout,
    output reg LFSR_enable, // enable LFSR
    output reg LFSR_count, // # of values to flash
    output reg LFSR_timer, // flash frequency
    output reg tenths_timer,
    output reg ones_timer,
    output reg [3:0] player_input,
    output reg [6:0] hex5_display, // leftmost
    output reg [6:0] hex4_display,
    output reg [6:0] hex3_display,
    output reg [6:0] hex2_display,
    output reg [6:0] hex1_display,
    output reg [6:0] hex0_display // rightmost


);

    reg [4:0] state;
    parameter main = 0, game_setup = 1, wait4start = 2, gameplay = 3;

    always @(posedge clk) begin
        if(!reset) begin

            state <= main;
        end

        else begin
            if(PSWD_match)begin
            case(state)
                main: begin
                    

                end

                game_setup:

                wait4start:

                gameplay:

                default: begin

                end

            endcase
            end
        end




    end


endmodule