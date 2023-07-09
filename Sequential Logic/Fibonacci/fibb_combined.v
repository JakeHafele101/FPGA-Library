`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/17/2022 12:18:17 PM
// Design Name: 
// Module Name: fibb_combined
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


module fibb_combined(
    input i_clk, i_reset,
    input i_start, 
    input [3:0] i_bcd1_n, i_bcd0_n, 
    output reg o_ready, o_done_tick, 
    output [3:0] o_bcd3, o_bcd2, o_bcd1, o_bcd0
    );
                
    //state declarations
    localparam [2:0] idle = 3'b000,
                     BCD_to_bin = 3'b001,
                     fib = 3'b010,
                     bin_to_BCD = 3'b011,
                     done = 3'b100;
                     
    reg [2:0] s_state_reg, s_state_next;
    reg [13:0] s_t0_reg, s_t0_next, s_t1_reg, s_t1_next;
    reg [6:0] s_n_reg, s_n_next;
    
    //BCD to binary conversion registers
    reg [13:0] s_bin_reg, s_bin_next;
    reg [3:0] s_bcd3_reg, s_bcd2_reg, s_bcd1_reg, s_bcd0_reg;
    reg [3:0] s_bcd3_next, s_bcd2_next, s_bcd1_next, s_bcd0_next;
    wire [3:0] s_bcd3_temp, s_bcd2_temp, s_bcd1_temp, s_bcd0_temp;
    
    //FSMD state and data structures
    always @(posedge i_clk, posedge i_reset)
        if (i_reset)
            begin
                s_state_reg <= idle;
                s_t0_reg <= 0;
                s_t1_reg <= 0;
                s_n_reg <= 0;
                s_bin_reg <= 0;
                s_bcd3_reg <= 0;
                s_bcd2_reg <= 0;
                s_bcd1_reg <= 0;
                s_bcd0_reg <= 0;
            end
        else
            begin
                s_state_reg <= s_state_next;
                s_t0_reg <= s_t0_next;
                s_t1_reg <= s_t1_next;
                s_n_reg <= s_n_next;
                s_bin_reg <= s_bin_next;
                s_bcd3_reg <= s_bcd3_next;
                s_bcd2_reg <= s_bcd2_next;
                s_bcd1_reg <= s_bcd1_next;
                s_bcd0_reg <= s_bcd0_next;
            end
     
     //FSMD next-state logic
     always @*
     begin
        s_state_next = s_state_reg;
        o_ready = 1'b0;
        o_done_tick = 1'b0;
        s_t0_next = s_t0_reg;
        s_t1_next = s_t1_reg;
        s_n_next = s_n_reg;
        s_bin_next = s_bin_reg;
        s_bcd3_next = s_bcd3_reg;
        s_bcd2_next = s_bcd2_reg;
        s_bcd1_next = s_bcd1_reg;
        s_bcd0_next = s_bcd0_reg;
        
        case(s_state_reg)
            
            idle:
                begin
                    o_ready = 1'b1;
                    if (i_start)
                        begin
                            s_state_next = BCD_to_bin;
                            s_n_next = 7'd7;
                            s_bcd1_next = i_bcd1_n;
                            s_bcd0_next = i_bcd0_n;
                            s_bin_next = 0;
                        end
                end
            BCD_to_bin: 
                begin
                    s_bcd1_next = (s_bcd1_temp > 7) ? s_bcd1_temp - 3 : s_bcd1_temp;
                    s_bcd0_next = (s_bcd0_temp > 7) ? s_bcd0_temp - 3 : s_bcd0_temp;
                    
                    s_bin_next[6:0] = {s_bcd0_reg[0], s_bin_reg[6:1]};
                    
                    s_n_next = s_n_reg - 1;
                    
                    if(s_n_next == 0)
                        begin
                            s_t0_next = 0;
                            s_t1_next = 14'd1;
                            s_n_next = s_bin_next[6:0]; //may need to be s_bin_next?
                            s_state_next = fib;
                        end
                end
            fib:
                begin
                    if(s_n_reg == 0)
                        begin
                            s_t1_next = 0;
                            s_state_next = bin_to_BCD;
                        end
                    else if (s_n_reg >= 21)
                        begin
                            s_t1_next = 14'd9999;
                            s_state_next = bin_to_BCD;
                        end
                    else if(s_n_reg == 1)
                        s_state_next = bin_to_BCD;
                    else
                        begin
                            s_t1_next = s_t1_reg + s_t0_reg;
                            s_t0_next = s_t1_reg;
                            s_n_next = s_n_reg - 1;
                        end
                    
                    if(s_state_next == bin_to_BCD)
                        begin
                            s_bcd0_next = 0; 
                            s_bcd1_next = 0;
                            s_bcd2_next = 0; 
                            s_bcd3_next = 0; 
                            s_n_next = 7'd14;
                            s_bin_next = s_t1_next;
                        end
                end
            bin_to_BCD: 
                begin
                    s_bin_next = s_bin_reg << 1;
                                        
                    s_bcd0_next = {s_bcd0_temp[2:0], s_bin_reg[13]};
                    s_bcd1_next = {s_bcd1_temp[2:0], s_bcd0_temp[3]};
                    s_bcd2_next = {s_bcd2_temp[2:0], s_bcd1_temp[3]};
                    s_bcd3_next = {s_bcd3_temp[2:0], s_bcd2_temp[3]};
                    
                    s_n_next = s_n_next - 1;
                    if(s_n_next == 0)
                        s_state_next = done;
                end
            done:
                begin
                    o_done_tick = 1'b1;
                    s_state_next = idle;
                end
            default: s_state_next = idle;
        endcase
     end
     
     //data path functions
     assign s_bcd0_temp = (s_state_reg == BCD_to_bin || s_state_reg == idle) ? {s_bcd1_reg[0], s_bcd0_reg[3:1]} : (s_bcd0_reg > 4) ? s_bcd0_reg + 3 : s_bcd0_reg;
     assign s_bcd1_temp = (s_state_reg == BCD_to_bin || s_state_reg == idle) ? {1'b0, s_bcd1_reg[3:1]}          : (s_bcd1_reg > 4) ? s_bcd1_reg + 3 : s_bcd1_reg;
     assign s_bcd2_temp = (s_bcd2_reg > 4) ? s_bcd2_reg + 3 : s_bcd2_reg;
     assign s_bcd3_temp = (s_bcd3_reg > 4) ? s_bcd3_reg + 3 : s_bcd3_reg;
     
     //output logic
     assign o_bcd0 = s_bcd0_reg;
     assign o_bcd1 = s_bcd1_reg;
     assign o_bcd2 = s_bcd2_reg;
     assign o_bcd3 = s_bcd3_reg;
    
endmodule
