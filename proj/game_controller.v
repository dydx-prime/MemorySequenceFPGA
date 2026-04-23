// ECE 5440
// Author: Juan Aguilar, 1246
// game_controller
// Controls the output signals from the control unit, once the authentication is passed
module game_controller(
    input clk,
    input reset,
    input load_in_p1,
    input rng_in,
    input time_out,
    input game_ctrl_enable,
    input game_start_btn,
    output reg logout,
    output reg load_out_p1,
    output reg timer_reconfig,
    output reg timer_enable,
    output reg rng_gen
);


    reg [2:0] state;
    parameter timer_restart = 0, wait_for_start = 1, gameplay = 2, gameover = 3;

    always @(posedge clk)begin
        if (reset == 1'b0 ) begin
            state <= timer_restart;
            logout <= 1'b0;
            load_out_p1  <= 1'b0;
            timer_reconfig  <= 1'b0;
            rng_gen <= 1'b1;
            timer_enable <= 1'b0;
        end
	    else begin
            if(game_ctrl_enable) begin
                case(state)
                    timer_restart: begin
                        logout <= 1'b0;
                        load_out_p1 <= 1'b0; 
                        timer_reconfig <= 1'b1;
                        rng_gen <= 1'b1;
                        timer_enable <= 1'b0;
                        state <= wait_for_start;
                    end

                    wait_for_start: begin
                        timer_reconfig <= 1'b0;
                        if(game_start_btn) begin
                            state <= gameplay;
                        end

                        else if(load_in_p1)begin
                            logout <= 1'b1;
                            state <= timer_restart;
                        end

                        else begin
                            load_out_p1 <= 1'b0; 
                            rng_gen <= 1'b1;
                            timer_enable <= 1'b0;
                            state <= wait_for_start;
                        end
                    end

                    gameplay: begin
                        timer_reconfig <= 1'b0;
                        rng_gen <= rng_in;
                        timer_enable <= 1'b1;
                        load_out_p1 <= load_in_p1; 

                        if(time_out)
                            state <= gameover;
                        else begin
                            state <= gameplay;
                        end
                    end

                    gameover: begin
                        load_out_p1 <= 1'b0; 
                        timer_reconfig <= 1'b0;
                        rng_gen <= 1'b1;
                        timer_enable <= 1'b0;

                        if(game_start_btn)
                            state <= timer_restart;

                        else if(load_in_p1)begin
                            logout <= 1'b1;
                            state <= timer_restart;
                        end

                        else begin
                            state <= gameover;
                        end
                    end

                    default: begin
                        state <= timer_restart;
                        logout <= 1'b0;
                        load_out_p1  <= 1'b0;
                        timer_reconfig  <= 1'b0;
                        rng_gen <= 1'b1;
                        timer_enable <= 1'b0;
                    end
                endcase
            end
	    end
    end

endmodule

