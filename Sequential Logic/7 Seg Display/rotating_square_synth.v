`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/07/2022 11:09:15 PM
// Design Name: 
// Module Name: rotating_square_synth
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


module rotating_square_synth(
    input CLK100MHZ,
    input btnC,
    input [15:0] sw,
    output [15:0] LED,
    output [3:0] an,
    output dp,
    output [6:0] seg
    );
    
    rotating_square square(.clk(CLK100MHZ), .reset(btnC), .en(sw[0]), .cw(sw[1]), .an(an), .segment({dp, seg}));
    
    assign LED[1:0] = sw[1:0];
    
endmodule
