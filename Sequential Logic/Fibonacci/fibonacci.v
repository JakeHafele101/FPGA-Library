`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/16/2022 09:09:46 PM
// Design Name: 
// Module Name: fibonacci
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module fibonacci(
    input i_clk, i_reset,
    input i_start, 
    input [3:0] i_bcd1_n, i_bcd0_n, 
    output o_ready, o_done_tick, 
    output [3:0] o_bcd3, o_bcd2, o_bcd1, o_bcd0
    );
    
    //BCD to binary conversion for n fib sequence
    wire s_bcd_bin_ready;
    wire s_bcd_bin_done_tick;
    wire [6:0] s_bin_n;
    
    BCD_to_binary BCD_to_bin(.clk(i_clk), .reset(i_reset), .start(i_start), .bcd1(i_bcd1_n), .bcd0(i_bcd0_n), .ready(s_bcd_bin_ready), .done_tick(s_bcd_bin_done_tick), .bin(s_bin_n));
        
    //state declarations
    localparam [1:0] idle = 2'b00,
                     op = 2'b01,
                     done = 2'b10;
                     
    reg [1:0] s_state_reg, s_state_next;
    reg [13:0] s_t0_reg, s_t0_next, s_t1_reg, s_t1_next;
    reg [6:0] s_n_reg, s_n_next;

    reg s_fib_ready;
    reg s_fib_done_tick;
    
    //FSMD state and data structures
    always @(posedge i_clk, posedge i_reset)
        if (i_reset)
            begin
                s_state_reg <= idle;
                s_t0_reg <= 0;
                s_t1_reg <= 0;
                s_n_reg <= 0;
            end
        else
            begin
                s_state_reg <= s_state_next;
                s_t0_reg <= s_t0_next;
                s_t1_reg <= s_t1_next;
                s_n_reg <= s_n_next;
            end
     
     //FSMD next-state logic
     always @*
     begin
        s_state_next = s_state_reg;
        s_fib_ready = 1'b0;
        s_fib_done_tick = 1'b0;
        s_t0_next = s_t0_reg;
        s_t1_next = s_t1_reg;
        s_n_next = s_n_reg;
        
        case(s_state_reg)
            
            idle:
                begin
                    s_fib_ready = 1'b1;
                    if (s_bcd_bin_done_tick)
                        begin
                            s_t0_next = 0;
                            s_t1_next = 14'd1;
                            s_n_next = s_bin_n;
                            s_state_next = op;
                        end
                end
            op:
                begin
                    if(s_n_reg == 0)
                        begin
                            s_t1_next = 0;
                            s_state_next = done;
                        end
                    else if (s_n_reg >= 21)
                        begin
                            s_t1_next = 14'd9999;
                            s_state_next = done;
                        end
                    else if(s_n_reg == 1)
                        s_state_next = done;
                    else
                        begin
                            s_t1_next = s_t1_reg + s_t0_reg;
                            s_t0_next = s_t1_reg;
                            s_n_next = s_n_reg - 1;
                        end
                end
            done:
                begin
                    s_fib_done_tick = 1'b1;
                    s_state_next = idle;
                end
            default: s_state_next = idle;
        endcase
     end
     
     //binary to BCD conversion, max output of 9999 for four seven seg display
     wire s_bin_bcd_ready;
     wire [3:0] s_bin_bcd1, s_bin_bcd0;
     
     binary_to_BCD bin_to_BCD(.clk(i_clk), .reset(i_reset), .start(s_fib_done_tick), .bin(s_t1_reg), .ready(s_bin_bcd_ready), .done_tick(o_done_tick), .bcd3(o_bcd3), .bcd2(o_bcd2), .bcd1(o_bcd1), .bcd0(o_bcd0)); 
     
     //output logic
     assign o_ready = s_bcd_bin_ready && s_fib_ready && s_bin_bcd_ready;
            
endmodule
