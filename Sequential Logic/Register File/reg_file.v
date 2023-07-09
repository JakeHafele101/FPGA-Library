`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/04/2022 08:40:22 PM
// Design Name: 
// Module Name: reg_file
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


module reg_file(
    input clk,
    input wr_en,
    input [W-1:0] w_addr, r_addr,
    input [B-1:0] w_data,
    output [B-1:0] r_data
    );
    
    parameter B = 8; //number of bits
    parameter W = 2; //number of address bits
    
    //signal declaration
    //array of [2**W-1:0] elements and each element is with data type reg [B-1:0]
    reg [B-1:0] array_reg [2**W-1:0];
    
    //body
    //write operation
    always @(posedge clk)
        if (wr_en)
            array_reg[w_addr] <= w_data;
    
    //read operation, can add more ports with another r_data output and r_addr read index
    assign r_data = array_reg[r_addr];
    
endmodule
