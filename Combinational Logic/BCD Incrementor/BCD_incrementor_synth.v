`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/03/2022 02:16:03 PM
// Design Name: 
// Module Name: BCD_incrementor_synth
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


module BCD_incrementor_synth(
    input CLK100MHZ,
    input [15:0] sw,
    input btnC,
    input btnU,
    output [15:0] LED,
    output [6:0] seg,
    output dp,
    output [3:0] an
    );
    
    wire [11:0] bcd_out;
    
    assign LED[11:0] = sw[11:0];
    assign LED[13:12] = {btnU, btnC};
    
    BCD_incrementor_12b bcd(.bcd_in(sw[11:0]), .en(btnC), .bcd_out(bcd_out));
    
    seven_seg_mux segment_display(.clk(CLK100MHZ), .reset(btnU), .hex3(4'hF), .hex2(bcd_out[11:8]), 
                                  .hex1(bcd_out[7:4]), .hex0(bcd_out[3:0]), .dp(4'b1111), .an_en(4'b0111), 
                                  .seg_out({dp, seg}), .an_out(an));
    
endmodule
