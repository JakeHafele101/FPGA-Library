`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/16/2022 11:57:17 PM
// Design Name: 
// Module Name: fibb_synth
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


module fibb_synth(
    input CLK100MHZ,
    input btnC, btnR,
    input [15:0] sw,
    output [15:0] LED, 
    output [3:0] an,
    output dp,
    output [6:0] seg
    );
    
    wire [3:0] bcd3, bcd2, bcd1, bcd0;
    
    assign LED[7:0] = sw[7:0];
    
//    fibonacci fib(.i_clk(CLK100MHZ), .i_reset(btnC), .i_start(btnR), .i_bcd1_n(sw[7:4]), .i_bcd0_n(sw[3:0]), .o_ready(LED[15]), .o_done_tick(LED[14]),
//                  .o_bcd3(bcd3), .o_bcd2(bcd2), .o_bcd1(bcd1), .o_bcd0(bcd0)); 
                  
    fibb_combined fib_comb(.i_clk(CLK100MHZ), .i_reset(btnC), .i_start(btnR), .i_bcd1_n(sw[7:4]), .i_bcd0_n(sw[3:0]), .o_ready(LED[15]), .o_done_tick(LED[14]),
                           .o_bcd3(bcd3), .o_bcd2(bcd2), .o_bcd1(bcd1), .o_bcd0(bcd0)); 
                  
    seven_seg_mux segment(.clk(CLK100MHZ), .reset(btnC), .duty_cycle(4'b1000), .hex3(bcd3), .hex2(bcd2), .hex1(bcd1), .hex0(bcd0),
                          .dp(4'b0000), .an_en(4'b1111), .seg_out({dp, seg}), .an_out(an));
    
endmodule
