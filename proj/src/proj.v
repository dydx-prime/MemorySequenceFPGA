// top module
module proj(
    input clk,
    input reset,
    input [3:0] id_input,
    input [3:0] player_input,
    input auth_button,
    input game_start_btn, // game start and player load
    input modeSel_btn,
    input logged_out,

    output ID_passed,
    output password_passed,
    output [6:0] hex5_display, // leftmost
    output [6:0] hex4_display,
    output [6:0] hex3_display,
    output [6:0] hex2_display,
    output [6:0] hex1_display,
    output [6:0] hex0_display // rightmost
);

    wire auth_shaped;
    button_shaper authentication(
        .clk   (clk),
        .reset (reset),
        .in    (auth_button),
        .out   (auth_shaped) // output
    );

    wire game_start_btn_shaped;
    button_shaper start_game_player_load(
        .clk   (clk),
        .reset (reset),
        .in    (game_start_btn),
        .out   (game_start_btn_shaped) // output
    );

    wire modeSel_btn_shaped;
    button_shaper mode_select(
        .clk   (clk),
        .reset (reset),
        .in    (modeSel_btn),
        .out   (modeSel_btn_shaped) // output
    );   

    wire [3:0] authFSM_index;
    controlUnit cU1(
        .clk          (clk),
        .reset        (reset),
        .auth_input   (id_input),
        .auth_btn     (auth_shaped),
        .logged_out   (logged_out),
        .ID_match     (ID_passed), // output
        .PSWD_match   (password_passed),
        .display_data (authFSM_index)
    );

    wire [6:0] authFSM_index_decoded;
    decoder7Segment auth_index(
        .game_data_to_decode(authFSM_index),
        .seven_segment_data(authFSM_index_decoded)
    );    

    wire [6:0] playerIn_decoded;
    wire [3:0] player_input_to_decode;
    decoder7Segment player(
        .game_data_to_decode(player_input_to_decode),
        .seven_segment_data(playerIn_decoded)
    );

    wire rng_on, rng_done;
    wire [3:0] rng_count, rng_speed, rng_val;
    RNG_top rng_unit(
        .clk       (clk),
        .reset     (reset),
        .RNG_on    (rng_on),
        .RNG_count (rng_count),
        .RNG_speed (rng_speed),
        .RNG_done  (rng_done), // output
        .RNG_val   (rng_val)
    );

    wire [3:0] ones_count, tenths_count, timer_speed;
    wire [3:0] tenths_out, ones_out;
    wire timer_reconfig, timer_enable;
    wire timer_out;
    digitTimer_top digit_timers(
        .clk            (clk),
        .reset          (reset),
        .timer_reconfig (timer_reconfig),   
        .timer_enable   (timer_enable),
        .d1_count       (tenths_count),	
        .d2_count       (ones_count),
        .count_val      (timer_speed),
        .timer_out      (timer_out), // output
        .digit1_out     (tenths_out),
        .digit2_out     (ones_out)
    );

    wire [3:0] gamemode_index;
	 wire logged_in = password_passed;
    game_ctrl gc1(
    .clk            (clk),
    .reset          (reset),
    .PSWD_match     (logged_in),
    .modeSel_btn    (modeSel_btn_shaped),
    .startGame_btn  (game_start_btn_shaped), 
    .auth_btn       (auth_shaped),
    .timer_out      (timer_out), 
    .RNG_seq_done   (rng_done), 
    .player_value   (player_input), 
    //.logout         (), // output

    .LFSR_enable    (rng_on),
    .LFSR_count     (rng_count),
    .LFSR_timer     (rng_speed),

    .timer_reconfig (timer_reconfig),
    .timer_enable   (timer_enable),
    .tenths_count   (tenths_count),
    .ones_count     (ones_count),
    .timer_speed    (timer_speed), 

    .player_input   (player_input_to_decode),
    .display_data   (gamemode_index)
    );


    wire [6:0] gamemode_index_decoded, rng_val_decoded, timer_tenths_decoded, timer_ones_decoded;
    decoder7Segment gamemode_index_val(
        .game_data_to_decode(gamemode_index),
        .seven_segment_data(gamemode_index_decoded)
    );   

    decoder7Segment rng_val_num(
        .game_data_to_decode(rng_val),
        .seven_segment_data(rng_val_decoded)
    );   

    decoder7Segment timer_tenths_val(
        .game_data_to_decode(tenths_out),
        .seven_segment_data(timer_tenths_decoded)
    );   

    decoder7Segment timer_ones_val(
        .game_data_to_decode(ones_out),
        .seven_segment_data(timer_ones_decoded)
    );   

    display_manager dm1(
		  .logged_in 				   (logged_in),
        .rng_on                  (rng_on),
        .timer_on                (timer_enable),
        .player_input_decoded    (playerIn_decoded), 
        .authenticationFSM_index (authFSM_index_decoded),
        .gamemode_index         (gamemode_index_decoded),
        .timer_tenths            (timer_tenths_decoded),
        .timer_ones              (timer_ones_decoded),
        .rng_values              (rng_val_decoded),
        
        .hex5_display            (hex5_display), // output
        .hex4_display            (hex4_display),
        .hex3_display            (hex3_display),
        .hex2_display            (hex2_display),
        .hex1_display            (hex1_display),
        .hex0_display            (hex0_display), // rightmost
    );


endmodule