`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/05/2022 11:00:07 PM
// Design Name: 
// Module Name: enhanced_stopwatch_synth
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


module enhanced_stopwatch_synth(
    input CLK100MHZ,
    input btnC,
    input [15:0] sw,
    output [15:0] LED,
    output dp,
    output [6:0] seg,
    output [3:0] an
    );
    
    assign LED[1:0] = sw[1:0];
    
    wire [3:0] d3, d2, d1, d0;
    
    enhanced_stopwatch enhanced_watch(.clk(CLK100MHZ), .go(sw[4]), .clr(btnC), .up(sw[5]), .d3(d3), .d2(d2), .d1(d1), .d0(d0));
    
    seven_seg_mux segment(.clk(CLK100MHZ), .reset(btnC), .duty_cycle(sw[3:0]), .hex3(d3), .hex2(d2), .hex1(d1), .hex0(d0),
                          .dp(4'b1010), .an_en(4'b1111), .seg_out({dp, seg}), .an_out(an));
endmodule
