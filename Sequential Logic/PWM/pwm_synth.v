`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/06/2022 09:27:13 PM
// Design Name: 
// Module Name: pwm_synth
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


module pwm_synth(
    input CLK100MHZ,
    input btnC,
    input [15:0] sw,
    output [15:0] LED,
    output dp,
    output [6:0] seg,
    output [3:0] an
    );
            
    seven_seg_mux segment(.clk(CLK100MHZ), .reset(btnC), .duty_cycle(sw[3:0]), .hex3(4'h3), .hex2(4'h2), .hex1(4'h1), .hex0(4'h0),
                          .dp(4'b1010), .an_en(4'b1111), .seg_out({dp, seg}), .an_out(an));
    
    assign LED[3:0] = sw[3:0];
    
endmodule
