`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/15/2022 08:56:50 PM
// Design Name: 
// Module Name: seven_seg
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

//On Basys 3, anode and cathode are driven low to drive LED
// Anode pins include: AN0,AN1,AN2,AN3
//Cathode pins include: CA, CB, CC, CD, CE, CF, CG, DP (decimal point)

module seven_seg(
    input [3:0] hex,
    input dp,
    output reg [7:0] segment //dp will be MSB, then A, B, C, D, E, F, G as LSB
    );
    
    always @*
    begin
        case(hex) //7'b G,F,E,D,C,B,A
            4'h0: segment[6:0] = 7'b1000000; //displays 0,
            4'h1: segment[6:0] = 7'b1111001; //displays 1
            4'h2: segment[6:0] = 7'b0100100; //displays 2
            4'h3: segment[6:0] = 7'b0110000; //displays 3
            4'h4: segment[6:0] = 7'b0011001; //displays 4
            4'h5: segment[6:0] = 7'b0010010; //displays 5
            4'h6: segment[6:0] = 7'b0000010; //displays 6
            4'h7: segment[6:0] = 7'b1111000; //displays 7
            4'h8: segment[6:0] = 7'b0000000; //displays 8
            4'h9: segment[6:0] = 7'b0010000; //displays 9
            4'hA: segment[6:0] = 7'b0001000; //displays A
            4'hB: segment[6:0] = 7'b0000011; //displays B
            4'hC: segment[6:0] = 7'b1000110; //displays C
            4'hD: segment[6:0] = 7'b0100001; //displays D
            4'hE: segment[6:0] = 7'b0000110; //displays E
            default: segment[6:0] = 7'b0001110; //defaults to displaying F
        endcase
        segment[7] = dp; //Sets MSB to decimal point LED output for seven seg
    end
endmodule
