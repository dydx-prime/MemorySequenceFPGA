// ECE 5440
// Author: Juan Aguilar, 1246
// authentication_FSM
// ID check and password check (crazy)
module authentication_FSM(
    input clk,
    input reset,
    input [3:0] auth_input,
    input auth_btn,
    input logged_out,

    output ID_match, // ID match
    output PSWD_match, // password match
    output reg [3:0] display_data
);
    wire [3:0] display_data_ID, display_data_PSWD;
    wire [2:0] internalID;
    ID_check ic1(
        .clk            (clk),
        .reset          (reset),
        .id_input       (auth_input),
        .auth_btn       (auth_btn),
        .logged_out     (logged_out),
        .auth_passed    (ID_match), // output
        .display_data   (display_data_ID),
        .internalID     (internalID)
    );

    wire ID_passed = ID_match;

    password_check pc1(
        .clk             (clk),
        .reset           (reset),
        .pswd_btn_press  (auth_btn),
        .internalID      (internalID),
        .password_input  (auth_input),
        .ID_check_passed (ID_passed),
        .logged_in       (PSWD_match), // output
        .display_data    (display_data_PSWD)
    );

    // ID or PSWD displayed
    always @(*) begin
        if(!ID_passed)
            display_data = display_data_ID;
        else
            display_data = display_data_PSWD;
    end

endmodule