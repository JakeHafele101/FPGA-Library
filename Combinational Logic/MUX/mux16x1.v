`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/12/2022 09:10:08 PM
// Design Name: 
// Module Name: mux16x1
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


module mux16x1(
    input [15:0] X,
    input [3:0] S,
    output [1:0] Y
    );
    
    reg Y;
    
    wire A, B, C, D; //Instantiate wires for outputs of intermittent 4x1 Mux's
    wire [1:0] S_01 = S[1:0]; //bits 0 and 1 of select line S
    wire [1:0] S_23 = S[3:2]; //bits 2 and 3 of select line S
    
    mux4x1 mux_1(X[0], X[1], X[2], X[3], S_01, A); //output A for X inputs 0 to 3
    mux4x1 mux_2(X[4], X[5], X[6], X[7], S_01, B); //output B for X inputs 4 to 7
    mux4x1 mux_3(X[8], X[9], X[10], X[11], S_01, C); //output C for X inputs 8 to 11
    mux4x1 mux_4(X[12], X[13], X[14], X[15], S_01, D); //output D for X inputs 12 to 15
    
    mux4x1 mux_5(A, B, C, D, S_23, Y); //Output Y for wire inputs from previous MUX blocks
    
//    always @(*) //this way also works, but I think its fun to include the other MUX blocks too
//        case(S)
//            4'b0000: Y = X[0];
//            4'b0001: Y = X[1];
//            4'b0010: Y = X[2];
//            4'b0011: Y = X[3];
//            4'b0100: Y = X[4];
//            4'b0101: Y = X[5];
//            4'b0110: Y = X[6];
//            4'b0111: Y = X[7];
//            4'b1000: Y = X[8];
//            4'b1001: Y = X[9];
//            4'b1010: Y = X[10];
//            4'b1011: Y = X[11];
//            4'b1100: Y = X[12];
//            4'b1101: Y = X[13];
//            4'b1110: Y = X[14];
//            4'b1111: Y = X[15];
//        endcase
    
endmodule
