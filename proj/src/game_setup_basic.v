module game_setup_basic(
    input clk,
    input reset,
    input modeSel_btn,
    input startGame_btn, // also acts as player load
    input auth_btn,

    output reg logout,
    output reg LFSR_enable, // enable LFSR
    output reg LFSR_count, // # of values to flash
    output reg LFSR_timer, // flash frequency
    output reg tenths_timer,
    output reg ones_timer,

);

    


endmodule