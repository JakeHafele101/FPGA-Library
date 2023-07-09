`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/12/2022 01:42:18 PM
// Design Name: 
// Module Name: clock_divider
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


module clock_divider(
    input clk, 
    input reset,
    input en,
    output tick
    );
    
    parameter DVSR = 50000000; //Mod-M counter for 0.5 second tick with 100MHZ clock
    
    //counter for clock frequency
    reg [31:0] ms_reg;         
    wire [31:0] ms_next;
    
                
    always @(posedge clk, posedge reset)
        if(reset)
            ms_reg <= 0;
        else if (en)
            ms_reg <= ms_next;
    
    //next-state logic
    assign ms_next = (reset || (ms_reg == DVSR && en)) ? 0 :
                     (en) ?   ms_reg + 1 :
                              ms_reg;
                              
    //output logic              
    assign tick = (ms_reg == DVSR) ? 1'b1 : 1'b0;
    
endmodule
