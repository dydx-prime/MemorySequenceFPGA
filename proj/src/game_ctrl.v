module game_ctrl(
    input clk,
    input reset,
    input PSWD_match,
    input modeSel_btn,
    input startGame_btn, // also acts as player load
    input auth_btn,
    input timer_out, // timer has reached 0
    input RNG_seq_done, // rng has flashed all values
    input [3:0] player_value, // basically player input
    //output reg logout,

    // rng stuff
    output reg LFSR_enable, // enable LFSR
    output reg [3:0] LFSR_count, // # of values to flash
    output reg [3:0] LFSR_timer, // flash frequency/speed

    // timer stuff
    output reg timer_reconfig,
    output reg timer_enable,
    output reg [3:0] tenths_count,
    output reg [3:0] ones_count,
    output reg [3:0] timer_speed, // = 9 for a 1sec pulse. Should probably be kept that way

    // general display info - to show what mode is being selected, player vals, etc
    output reg [3:0] player_input,
    output reg [3:0] display_data
);

    reg [3:0] player_num_of_entries; // # of confirmed player entries 
    reg [1:0] game_mode_index; // swaps between 3 gamemodes
    reg [4:0] state;
    parameter initialize = 0, main = 1, game_setup = 2, gameplay = 3, rng_flash = 4, delay = 5, delay2 = 6, enable_timer = 7;

    always @(posedge clk) begin
        if(!reset) begin
            //logout <= 1'b0;
            LFSR_enable <= 1'b0;
            LFSR_count <= 4'b0;
            LFSR_timer <= 4'b0; 
                    
            timer_reconfig <= 1'b0;
            timer_enable <= 1'b0;
            tenths_count <= 4'b0;
            ones_count <= 4'b0;
            timer_speed <= 4'b0; 

            player_input <= 4'd0; 
            display_data <= 4'd0;
            game_mode_index <= 2'b0;
            state <= main;
        end

        else begin
            if(PSWD_match)begin

            case(state)
                main: begin
                    state <= main;
                    display_data <= game_mode_index;

                    if(modeSel_btn || game_mode_index == 2'b0)begin
                        game_mode_index <= game_mode_index + 2'b1; // we start at 1 instead of 0. 1 to 3
                    end

                    else if (startGame_btn) begin
                        state <= game_setup;
                    end
                end

                game_setup: begin
                    state <= delay;
                    LFSR_enable <= 1'b0; // not yet, let everything load first
                    timer_reconfig <= 1'b1;
                    timer_enable <= 1'b0; // not yet, let values flash first

                    if(game_mode_index == 2'd1) begin // easy mode
                        LFSR_count <= 4'd5;
                        LFSR_timer <= 4'd13; 
                        
                        tenths_count <= 4'd9;
                        ones_count <= 4'd9;
                        timer_speed <= 4'd9;                         
                    end

                    if(game_mode_index == 2'd2) begin // normal mode
                        LFSR_count <= 4'd9;
                        LFSR_timer <= 4'd9; 
                        
                        tenths_count <= 4'd6;
                        ones_count <= 4'd0;
                        timer_speed <= 4'd9;                             
                    end

                    if(game_mode_index == 2'd3) begin // hard mode
                        LFSR_count <= 4'd12;
                        LFSR_timer <= 4'd4; 
                        
                        tenths_count <= 4'd1;
                        ones_count <= 4'd5;
                        timer_speed <= 4'd9;       
                    end
                end

                delay: begin // lets values pass onto RNG top
                    state <= delay2;
                end

                delay2: begin
                    state <= rng_flash;
					LFSR_enable <= 1'b1; // enable now that signals loaded inside
                end

                rng_flash: begin
                    state <= rng_flash;
                    timer_reconfig <= 1'b0;
                    if(RNG_seq_done) begin
                        state <= enable_timer;
                        timer_enable <= 1'b1; // begin countdown after rng has been flashed
                        player_num_of_entries <= 4'b0;
                        LFSR_enable <= 1'b0;
                    end
                end

                enable_timer:begin // let enable timer to pass
                    state <= gameplay;
                end

                gameplay: begin
                    state <= gameplay;
                    player_input <= player_value; // transparent
                    if(timer_enable && (player_num_of_entries == LFSR_count || timer_out)) begin
                        state <= main;
                        player_input <= 4'd0; // opqaque
                        timer_enable <= 1'b0;
                        timer_reconfig <= 1'b1;
                    end

                    else if(startGame_btn) begin
                        player_num_of_entries <= player_num_of_entries + 4'b1;
                    end

                end

                default: begin
                    //logout <= 1'b0;
                    LFSR_enable <= 1'b0;
                    LFSR_count <= 4'b0;
                    LFSR_timer <= 4'b0;

                    timer_reconfig <= 1'b0;
                    timer_enable <= 1'b0;
                    tenths_count <= 4'b0;
                    ones_count <= 4'b0;
                    timer_speed <= 4'b0;

                    player_input <= 4'b0;
                    display_data <= 4'b0;
                    game_mode_index <= 2'b0;
                    state <= main;
                end

            endcase

            end
        end
    end


endmodule