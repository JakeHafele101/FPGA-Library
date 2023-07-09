`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/02/2022 03:39:53 PM
// Design Name: 
// Module Name: left_right_barrel_shifter
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

//
module barrel_shifter_lr_8b(
    input [7:0] a,        //input bits to be shifted
    input lr,             //specifies shift direction by 1 bit. If 0, shift left. If 1, shift right
    input [2:0] amt,            //amount of bits to shift
    output reg [7:0] y    //shifted output bits either left or right
    );
    
    //stage registers to store shift values based on amt bit shift selection
    reg [7:0] s0, s1;
    
    always @*
        begin
            if(lr) //if 1, shift left. MSB set to LSB
                begin
                    s0 = amt[0] ? {a[6:0], a[7]} : a; //shift 1 or 0 bit left
                    s1 = amt[1] ? {s0[5:0], s0[7:6]} : s0; //shift 2 or 0 bits left
                    y  = amt[2] ? {s1[3:0], s1[7:4]} : s1; //shift 4 or 0 bits left
                end
            else  //if 0, shift right. LSB set to MSB
                begin
                    s0 = amt[0] ? {a[0], a[7:1]} : a; //shift 1 or 0 bit right
                    s1 = amt[1] ? {s0[1:0], s0[7:2]} : s0; //shift 2 or 0 bits right
                    y  = amt[2] ? {s1[3:0], s1[7:4]} : s1; //shift 4 or 0 bits right
                end
        end
    
endmodule