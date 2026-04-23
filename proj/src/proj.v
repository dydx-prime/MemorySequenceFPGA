module proj(
    input clk,
    input reset,
    input [3:0] id_input,
    input [3:0] player_input,
    input auth_button,
    input game_start_btn, // game start and player load
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
    decoder7Segment player(
        .game_data_to_decode(player_input),
        .seven_segment_data(playerIn_decoded)
    );
    

    wire logged_in = password_passed;
    display_manager dm1(
        .logged_in               (logged_in),
        .player_input_decoded    (playerIn_decoded), 
        .authenticationFSM_index (authFSM_index_decoded),
        .hex5_display            (hex5_display), // output
        .hex4_display            (hex4_display),
        .hex3_display            (hex3_display),
        .hex2_display            (hex2_display),
        .hex1_display            (hex1_display),
        .hex0_display            (hex0_display), // rightmost
    );


endmodule