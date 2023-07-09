`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/03/2022 12:41:02 AM
// Design Name: 
// Module Name: BCD_incrementor_12b
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


module BCD_incrementor_12b(
    input [11:0] bcd_in,
    input en,
    output [11:0] bcd_out
    );
    
    wire carry0, carry1, carry2;
    
    bcd_incrementor bcd0(.in(bcd_in[3:0]), .en(en), .carry(carry0), .out(bcd_out[3:0]));
    bcd_incrementor bcd1(.in(bcd_in[7:4]), .en(carry0), .carry(carry1), .out(bcd_out[7:4]));
    bcd_incrementor bcd2(.in(bcd_in[11:8]), .en(carry1), .carry(carry2), .out(bcd_out[11:8]));
    
endmodule
