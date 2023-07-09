`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/11/2022 06:12:33 PM
// Design Name: 
// Module Name: rotating_banner_synth
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


module rotating_banner_synth(
    input CLK100MHZ,
    input btnC,
    input [15:0] sw,
    output [15:0] LED,
    output [3:0] an,
    output dp,
    output [6:0] seg
    );
    
    wire [15:0] hex;
    
    assign LED[1:0] = sw[1:0];
    
    rotating_banner banner(.clk(CLK100MHZ), .reset(btnC), .en(sw[0]), .dir(sw[1]), .m(32'h01234567), .hex(hex));
    
    seven_seg_mux segment_mux(.clk(CLK100MHZ), .reset(btnC), .duty_cycle(4'b1000), .hex3(hex[15:12]), .hex2(hex[11:8]), .hex1(hex[7:4]), .hex0(hex[3:0]), .dp(4'b1111), .an_en(4'b1111), .an_out(an), .seg_out({dp, seg}));

    
endmodule
