`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/14/2022 09:41:28 PM
// Design Name: 
// Module Name: up_down_counter_4b
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


module up_down_counter_4b(
    input clk, reset,
    input inc, dec,
    output reg [3:0] q
    );
    
    always @(posedge clk, posedge reset)
        if (reset)
            q <= 0;
        else if (inc && q < 9)
            q <= q + 1;
        else if (dec && q > 0)
            q <= q - 1;
endmodule