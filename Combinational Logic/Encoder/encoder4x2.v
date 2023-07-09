`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/12/2022 08:33:33 PM
// Design Name: 
// Module Name: decoder2x4
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

//4 bit priority encode, implemented with casex statement
module encoder4x2(
    input [3:0] X,
    input en,
    output reg [1:0] Y
    );
    
    always @*
        casex({en, X})
            5'b11???: Y = 11;
            5'b101??: Y = 10;
            5'b1001?: Y = 01;
            5'b10001: Y = 00;
            default: Y = 00;
        endcase
    
endmodule