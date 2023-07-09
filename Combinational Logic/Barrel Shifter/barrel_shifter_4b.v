`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/15/2022 10:51:35 PM
// Design Name: 
// Module Name: barrel_shifter_4b
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


module barrel_shifter_4b(
    input [3:0] X,
    input [1:0] shift,
    output reg [3:0] Y
    );
    
    always @*
        case(shift)
            2'b00: Y = X;
            2'b01: Y = {X[0], X[2:0]};
            2'b10: Y = {X[1:0], X[3:2]};
            2'b11: Y = {X[2:0], X[3]};
        endcase
        
endmodule
