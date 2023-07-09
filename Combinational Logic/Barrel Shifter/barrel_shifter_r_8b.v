`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/02/2022 06:19:13 PM
// Design Name: 
// Module Name: barrel_shifter_r_8b
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


module barrel_shifter_r_8b(
    input [7:0] a,        //input bits to be shifted
    input lr,             //specifies shift direction by 1 bit. If 0, shift left. If 1, shift right
    input [2:0] amt,            //amount of bits to shift
    output reg [7:0] y    //shifted output bits either left or right
    );
    
    //temp register for reversing logic on left shift
    reg [7:0] temp;
    
    //stage registers to store shift values based on amt bit shift selection
    reg [7:0] s0, s1, s2;
    
    always @*
        begin
            if(lr) //if 1, shift left. reverse before and after right shift
                temp = {a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7]}; //reverse input a, prep for left shift
            else  //if 0, assign temp as a is for right shift below
                temp = a[7:0]; //no reverse for a, prep forshift right
                
            s0 = amt[0] ? {temp[0], temp[7:1]} : temp; //shift 1 or 0 bit right
            s1 = amt[1] ? {s0[1:0], s0[7:2]} : s0; //shift 2 or 0 bits right
            s2  = amt[2] ? {s1[3:0], s1[7:4]} : s1; //shift 4 or 0 bits right
            
            if(lr) //shift left, reverse order
                y = {s2[0], s2[1], s2[2], s2[3], s2[4], s2[5], s2[6], s2[7]};
            else //shift right, assign s2 output for right shifts
                y = s2[7:0];
        end
        
endmodule
