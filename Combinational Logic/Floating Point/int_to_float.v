`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/03/2022 08:44:08 PM
// Design Name: 
// Module Name: int_to_float
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


module int_to_float(
    input [7:0] int,          //8 bit signed integer
    output reg [12:0] float   //13 bit floating point number
    );
    
    reg [7:0] int_mag; //magnitude of int, exludes sign that is MSB
    
    reg [3:0] significant_bit; //bit location of most significant 1 in int
    
    always @*
    begin
        float[12] = int[7]; //assign sign bit to MSB
        
        //find magnitude of integer by converting from 2's complement if negative
        if(int[7]) //if integer is negative, convert from 2's complement
            begin
                if(int[6:0] == 0) //if -128, set mag to 128 with 8th bit
                    int_mag = 8'b10000000;
                else              //otherwise, subtract by 1 bit and invert from 2's complement
                    int_mag = {0, ~(int[6:0] - 1'b1)};
            end
        else       //if integer is positive, can assign magnitude directly
            int_mag = {0, int[6:0]};
        
        //case statement to find most significant 1 bit, to shift for exponential
        casex(int_mag[7:0])
                8'b1???????: significant_bit = 4'b0111; //7
                8'b01??????: significant_bit = 4'b0110; //6
                8'b001?????: significant_bit = 4'b0101; //5
                8'b0001????: significant_bit = 4'b0100; //4
                8'b00001???: significant_bit = 4'b0011; //3
                8'b000001??: significant_bit = 4'b0010; //2
                8'b0000001?: significant_bit = 4'b0001; //1
                8'b00000001: significant_bit = 4'b0000; //0
                default: significant_bit = 4'b0000; //no significant bit found, default value set to 0 for exponential set
        endcase
        
        //assign exponent portion of floating point 
        float[11:8] = significant_bit;
        
        //assign mantissa point of floating output
        if(int_mag != 0) //if magnitude was not 0, shift bits appropriately based on MSB 1 location
            float[7:0] = int_mag << (8 - significant_bit);
        else             //if magnitude was 0, set mantissa to 0
            float[7:0] = 8'b00000000;
    end
    
endmodule

//128