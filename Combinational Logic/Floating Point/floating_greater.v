`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/03/2022 05:56:55 PM
// Design Name: 
// Module Name: floating_greater
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


module floating_greater(
    input [12:0] a,   //floating point input a
    input [12:0] b,   //floating point input b
    output reg gt     //outputs 1 when a is greater than b
    );

    always @*
    begin
        if(a[12] != b[12]) //a and b have different signs
            begin
                if(b[12] & (a[11:0] != b[11:0])) //if b is negative(1) and different magnitude, gt set to 1 (a greater)
                    gt = 1'b1;
                else      //if b is positive(0) or same magnitude, gt set to 0 (b greater)
                    gt = 1'b0;
            end
        else //a and b have same sign, compare magnitude (first exp, then significands if same exp)
            begin 
                if(((a[11:0] > b[11:0]) & ~a[12]) | ((a[11:0] < b[11:0]) & a[12])) //if a has larger magnitude than b and positive, or a has smaller magnitude than b and negative then gt is 1
                    gt = 1'b1;
                else                  //in all other cases, gt is 0 
                    gt = 1'b0;
            end
    end
    
endmodule
