`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/13/2022 05:53:37 PM
// Design Name: 
// Module Name: counter_8b
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


module counter_8b(
    input clk, reset,
    input en,
    output reg [7:0] q
    );
    
    always @(posedge clk, posedge reset)
        if (reset)
            q <= 0;
        else if (en)
            q <= q + 1;
    
endmodule
