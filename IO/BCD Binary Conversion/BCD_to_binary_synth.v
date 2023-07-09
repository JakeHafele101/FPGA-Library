`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/16/2022 06:52:26 PM
// Design Name: 
// Module Name: BCD_to_binary_synth
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


module BCD_to_binary_synth(
    input CLK100MHZ,
    input btnC, btnR,
    input [15:0] sw,
    output [15:0] LED, 
    output [3:0] an,
    output dp,
    output [6:0] seg
    );
        
    BCD_to_binary binary(.clk(CLK100MHZ), .reset(btnC), .start(btnR), .bcd1(sw[7:4]), .bcd0(sw[3:0]), .ready(LED[15]), .done_tick(LED[14]), .bin(LED[6:0])); 
    
    seven_seg_mux segment(.clk(CLK100MHZ), .reset(btnC), .duty_cycle(4'b1000), .hex3(sw[7:4]), .hex2(sw[3:0]), .hex1(4'hF), .hex0(4'hF),
                          .dp(4'b0000), .an_en(4'b1100), .seg_out({dp, seg}), .an_out(an));
    
endmodule
