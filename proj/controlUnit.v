// ECE 5440
// Author: Juan Aguilar, 1246
// controlUnit
// Controls the output load signals generated from the player and authenticator

module controlUnit(
    input clk,
    input reset,
    input load_in_control,
    input load_in_p1,
    input rng_in,
    input time_out,
    input [3:0] number_in,

    output load_out_p1,
    output timer_reconfig,
    output timer_enable,
    output rng_gen,
    output reg logged_out,
    output reg logged_in,
    output [3:0] display_data
);

    wire pswd_logged_out, authenticated;

    authentication_FSM auth(.clk(clk), .reset(reset), .id_input(number_in),
                            .pswd_btn_press(load_in_control),
                            .logged_out(pswd_logged_out),
                            .auth_passed(authenticated),
                            .display_data(display_data));

    game_controller game_ctrl(.clk(clk), .reset(reset), .load_in_p1(load_in_p1), .rng_in(rng_in),
                              .time_out(time_out), .game_ctrl_enable(authenticated), .game_start_btn(load_in_control),
                              .logout(pswd_logged_out),
                              .load_out_p1(load_out_p1),
                              .timer_reconfig(timer_reconfig),
                              .timer_enable(timer_enable),
                              .rng_gen(rng_gen));

    always@(*) begin
        if(authenticated) begin
            logged_in = 1'b1;
            logged_out = ~logged_in;
        end
        else begin
            logged_in = 1'b0; 
            logged_out = ~logged_in;
        end
    end

endmodule
