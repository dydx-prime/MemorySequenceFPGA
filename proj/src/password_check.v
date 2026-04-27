// ECE 5440
// Author: Juan Aguilar, 1246
// checking last 4 digits of ID

module password_check(
    input clk,
    input reset,
    input pswd_btn_press,
    input [2:0] internalID,
    input [3:0] password_input,
    input ID_check_passed,
    output reg logged_in,
    //output reg [2:0] playerID,
    output reg [3:0] display_data
);

    reg [5:0] address;

    reg correct_flag;
    reg [2:0] count;

    wire[3:0] rom_value;
    ROM_PSWD pswd_repo(.address(address), .clock(clk), .q(rom_value));
    reg [3:0] address_val_stored;

    reg [4:0] state;

    parameter check_btn_press = 0, ROM_fetch = 1, cycle1 = 2, cycle2 = 3,
              ROM_catch = 4, compare = 5, verify = 6, success = 7, init = 8;

    always@(posedge clk)begin
        if (!reset || !ID_check_passed) begin
            state <= init;
            logged_in <= 1'b0;
            count <= 3'b000;
            correct_flag <= 1'b1;
            display_data <= 4'b0000;
            address <= {internalID , 3'b000};
        end

        else begin
            if(ID_check_passed) begin
            case(state)
                init: begin
                    state <= check_btn_press;
                    logged_in <= 1'b0;
                    count <= 3'b000;
                    correct_flag <= 1'b1;
                    display_data <= 4'b0000;
                    address <= {internalID , 3'b000}; 
                end

                check_btn_press: begin
                    display_data <= count + 4'b1;
                    logged_in <= 1'b0;

                    if(pswd_btn_press) 
                        state <= ROM_fetch;
                    else
                        state <= check_btn_press;
                end

                ROM_fetch: begin
                    state <= cycle1;
                end

                cycle1: begin
                    state <= cycle2;
                end

                cycle2: begin
                    address_val_stored <= rom_value;
                    state <= ROM_catch;
                end

                ROM_catch: begin
                    state <= compare;
                end

                compare: begin

                    correct_flag <= correct_flag & (address_val_stored == password_input);

                    if (count == 3'b101)
                        state <= verify;

                    // next val
                    else begin
                        address <= address + 1'b1;
                        count <= count + 1'b1;
                        state <= check_btn_press;    
                    end
        
                end

                verify: begin
                    if(correct_flag) begin
                        state <= success;
                    end
                        
                    else begin
                        count <= 3'b000;
                        correct_flag <= 1'b1;
                        address <= {internalID , 3'b000};
                        state <= check_btn_press;
                        display_data <= 4'b0001; // might be wrong
                    end
                end

                success: begin
                    logged_in <= 1'b1;
                end
                
            default: begin
                state <= init;
                logged_in <= 1'b0;
                count <= 3'b000;
                correct_flag <= 1'b1;
                display_data <= 4'b0000;
                address <= {internalID , 3'b000};
            end

            endcase
            end

        end
    end

endmodule