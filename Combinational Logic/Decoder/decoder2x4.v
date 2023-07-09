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


module decoder2x4(
    input [1:0] X,
    input en,
    output reg [3:0] Y
    );
    
    always @*
        casex({en, X})
            3'b0??: Y = 4'b0000;
            3'b100: Y = 4'b0001;
            3'b101: Y = 4'b0010;
            3'b110: Y = 4'b0100;
            3'b111: Y = 4'b1000;
            //default: Y = 4'b0000; //Can use instead of first case
        endcase
    
endmodule