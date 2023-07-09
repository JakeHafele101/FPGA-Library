`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/19/2022 07:23:31 PM
// Design Name: 
// Module Name: reaction_timer_synth
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


module reaction_timer_synth(
    input CLK100MHZ,
    input btnC, btnL, btnR,
    output [15:0] LED, 
    output [3:0] an,
    output dp,
    output [6:0] seg
    );
    
    wire [3:0] s_seg3, s_seg2, s_seg1, s_seg0;
    wire [3:0] s_dp;
    wire [3:0] s_an;
    
    reaction_timer react(.i_clk(CLK100MHZ), .i_reset(btnC), .i_start(btnL), .i_stop(btnR), .o_stimulus(LED[0]), 
                         .o_seg3(s_seg3), .o_seg2(s_seg2), .o_seg1(s_seg1), .o_seg0(s_seg0), .o_dp(s_dp), .o_an(s_an));
                         
    seven_seg_mux_reaction seg_mux(.clk(CLK100MHZ), .reset(btnC), .seg3(s_seg3), .seg2(s_seg2), .seg1(s_seg1), .seg0(s_seg0), 
                                   .dp_en(s_dp), .an_en(s_an), .segment({dp, seg}), .an(an));
    
endmodule
