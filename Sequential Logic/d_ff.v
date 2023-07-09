`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/04/2022 07:44:45 PM
// Design Name: 
// Module Name: d_ff
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


module d_ff(
    input clk,
    input d,
    output reg q
    );
    
    //Always block activated when clk changes from 0 to 1, on rising edge
    //d is not included in sensitivity list, only sampled on rising edge
    always @(posedge clk)
        q <= d;
    
endmodule
