`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/14/2022 06:20:54 PM
// Design Name: 
// Module Name: comparator_2b
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

//outputs 1 if A and B are equal, 0 if mismatch
module comparator_2b(
    input A,
    input B,
    output Y
    );
    
    assign Y = (!A&&!B)||(A&&B);
    
    
endmodule
