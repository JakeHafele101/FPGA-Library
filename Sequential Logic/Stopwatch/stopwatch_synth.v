`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/05/2022 09:57:32 PM
// Design Name: 
// Module Name: stopwatch_synth
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


module stopwatch_synth(
    input CLK100MHZ,
    input btnC,
    input [15:0] sw,
    output [15:0] LED,
    output dp,
    output [6:0] seg,
    output [3:0] an
    );
    
    assign LED[0] = sw[4];
    
    wire [3:0] d2, d1, d0;
    
    stopwatch watch(.clk(CLK100MHZ), .go(sw[4]), .clr(btnC), .d2(d2), .d1(d1), .d0(d0));
    
    seven_seg_mux segment(.clk(CLK100MHZ), .reset(btnC), .duty_cycle(sw[3:0]), .hex3(4'hF), .hex2(d2), .hex1(d1), .hex0(d0),
                      .dp(4'b0010), .an_en(4'b0111), .seg_out({dp, seg}), .an_out(an));
    
endmodule
