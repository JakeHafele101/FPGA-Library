`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/12/2022 11:19:04 AM
// Design Name: 
// Module Name: mux_4_to_1
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


module mux_4_to_1(
    input [3:0] X,
    input [1:0] S,
    output Y
    );
    
    reg Y;
     
    always @(X or S)
        case(S)
            2'b00: Y = X[0];
            2'b01: Y = X[1];
            2'b10: Y = X[2];
            2'b11: Y = X[3];
        endcase
endmodule

