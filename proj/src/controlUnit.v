module controlUnit(
    input clk,
    input reset,
    input [3:0] auth_input,
    input auth_btn,
    input logged_out, // rm once game setup is implemented

    output ID_match,
    output PSWD_match,
    output [3:0] display_data
    //output logged_in
);

    authentication_FSM AFSM1(
        .clk          (clk),
        .reset        (reset),
        .auth_input   (auth_input),
        .auth_btn     (auth_btn),
        .logged_out   (logged_out),
        .ID_match     (ID_match), // output
        .PSWD_match   (PSWD_match),
        .display_data (display_data)
    );


endmodule