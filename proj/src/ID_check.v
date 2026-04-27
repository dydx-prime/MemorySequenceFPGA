// ECE 5440
// Author: Juan Aguilar, 1246
// checking last 4 digits of ID

module ID_check(
    input clk,
    input reset,
    input [3:0] id_input,
    input auth_btn,
    input logged_out,
    // input pswd_reset,
    output reg auth_passed, // password match
    output reg [3:0] display_data,
    output reg [2:0] internalID
);

   
    reg [1:0] count = 2'b00;
    reg [2:0] address_index = 3'b000;

    reg [5:0] address; // address{address_index, 1'b0, count}
    // address1 = 6'b00_0000;
    // address2 = 6'b00_1000;
    // address3 = 6'b01_0000;
    // address4 = 6'b01_1000;
	 // address5 = 6'b10_0000;
	 // address6 = 6'b10_1000;
	 
    wire[3:0] rom_value;
    ROM_ID passwords(.address(address), .clock(clk), .q(rom_value));
    reg [3:0] address_val_stored;

    reg [4:0] state;
    reg [5:0] correct_flag;

    parameter check_btn_press = 0, ROM_fetch = 1, cycle1 = 2, cycle2 = 3,
              ROM_catch = 4, compare = 5, verify = 6, success = 7, init = 8;

    always@(posedge clk)begin
        if (!reset || logged_out) begin
            state <= init;
            auth_passed <= 1'b0;
            count <= 2'b00;
            address_index <= 3'b000;
            address <= 6'b000000;
            correct_flag <= 6'b111111;
            display_data <= 4'b0000;
        end
        else begin
            case(state)
					 init: begin
				state <= check_btn_press;
            auth_passed <= 1'b0;
            count <= 2'b00;
            address_index <= 3'b000;
            address <= 6'b000000;
            correct_flag <= 6'b111111;
            display_data <= 4'b0000;
					 
					 end
					 
                check_btn_press: begin
                    display_data <= count + 4'b1;
                    auth_passed <= 1'b0;
                    if(auth_btn) begin			
                        state <= ROM_fetch;
								end
                    else
                        state <= check_btn_press;
                end

                ROM_fetch: begin
                    state <= cycle1;
                    auth_passed <= 1'b0;
                end

                cycle1: begin
                    auth_passed <= 1'b0;
                    state <= cycle2;
                end

                cycle2: begin
                    auth_passed <= 1'b0;
                    address_val_stored <= rom_value;
                    state <= ROM_catch;
                end

                ROM_catch: begin
                    auth_passed <= 1'b0;
                    state <= compare;
                end

                compare: begin
                    correct_flag[address_index] <= correct_flag[address_index] & (address_val_stored == id_input);

                    if (count == 2'b11 && address_index == 3'b101)
                        state <= verify;

                    // next val
                    else if(address_index == 3'b101) begin
                        address_index <= 3'b000;
                        count <= count + 1'b1;
                        address <= {3'b000, 1'b0, count + 1'b1};
                        state <= check_btn_press;    
                    end

                    // loop
                    else begin
                        address_index <= address_index + 1'b1;
                        address <= {address_index + 1'b1, 1'b0, count};
                        state <= ROM_fetch;   
                    end           
                end

                verify: begin
                    if(correct_flag != 6'b000000)begin
                        state <= success;
                     end
                    else begin
                        count <= 2'b00;
                        address_index <= 3'b000;
                        correct_flag <= 6'b111111;
                        address <= {2'b00, 1'b0, 2'b00};
                        state <= check_btn_press;
                        display_data <= 4'b0001;
                    end
                end

                success: begin
                    auth_passed <= 1'b1;
                    // lsb is first entry
                    internalID <= (correct_flag[0]) ? 3'd0 :
                                      (correct_flag[1]) ? 3'd1 :
                                      (correct_flag[2]) ? 3'd2 :
                                      (correct_flag[3]) ? 3'd3 :
                                      (correct_flag[4]) ? 3'd4 : 3'd5;
                end

            default: begin
                state <= init;
                auth_passed <= 1'b0;
                count <= 2'b00;
                address_index <= 3'b000;
                address <= 6'b000000;
                correct_flag <= 6'b111111;
                display_data <= 4'b0000;
            end

            endcase
        end
    end

endmodule