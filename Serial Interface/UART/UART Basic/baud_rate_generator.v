`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/21/2022 11:31:58 AM
// Design Name: 
// Module Name: baud_rate_generator
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

//Mod-M counter with default 326 for 19,200 baud rate
module baud_rate_generator(
    input i_clk, i_reset, 
    output [N-1:0] o_count,
    output o_baud_tick
    );
    
    parameter M = 326; //(100*10^6)/(Baud*16) and round up. default baud rate is 19,200
    parameter N = 16;
    
    reg [N-1:0] s_count_reg;
    
    always @(posedge i_clk, posedge i_reset)
        if (i_reset)
            s_count_reg <= 0;
        else
            s_count_reg <= (s_count_reg == M) ? 0 : s_count_reg + 1;
    
    assign o_count = s_count_reg;    
    assign o_baud_tick = s_count_reg == M;
    
endmodule
