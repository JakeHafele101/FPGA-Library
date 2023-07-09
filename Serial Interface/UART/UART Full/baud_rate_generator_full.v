`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/24/2022 02:47:03 PM
// Design Name: 
// Module Name: baud_rate_generator_full
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


module baud_rate_generator_full(
    input i_clk, i_reset, 
    input [1:0] i_bd_rate,        //bd rate select: 00 is 1200, 01 is 2400, 10 is 4800, 11 is 9600
    output [15:0] o_count,
    output o_baud_tick
    );
        
    wire [15:0] M;
    
    reg [15:0] s_count_reg;
    
    //(100*10^6)/(Baud*16) and round up
    assign M = i_bd_rate == 2'b00 ? 16'd5209 : //1200 baud rate
               i_bd_rate == 2'b01 ? 16'd2605 : //2400 baud rate
               i_bd_rate == 2'b10 ? 16'd1302 : //4800 baud rate
                                    16'd652; //9600 baud rate
    
    always @(posedge i_clk, posedge i_reset)
        if (i_reset)
            s_count_reg <= 0;
        else
            s_count_reg <= (s_count_reg >= M) ? 0 : s_count_reg + 1; //checks if greater if baud rate changed to lower amount        
    
    assign o_count = s_count_reg;    
    assign o_baud_tick = s_count_reg == M;
    
endmodule
