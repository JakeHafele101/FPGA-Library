`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/05/2022 08:46:59 PM
// Design Name: 
// Module Name: stopwatch
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


module stopwatch(
    input clk,                //input clock, 100MHZ on Basys 3
    input go,                 //go signal to start/stop counter
    input clr,                //clr signal to reset counter
    output [3:0] d2, d1, d0   //output for 10, 1, and 0.1 increments on counter
    );
    
    parameter DVSR = 10000000; //Mod-M counter for 0.1 second tick with 100MHZ clock
    
    reg [31:0] ms_reg;         
    wire [31:0] ms_next;
    
    reg [3:0] d2_reg, d1_reg, d0_reg;         //BCD second registers
    wire [3:0] d2_next, d1_next, d0_next;     //BCD second next value (stay same, count up, roll over from 9 to 0)
    
    wire d2_en, d1_en, d0_en;                 //Enable status of if 10, 1, and 0.1 second should count
    
    wire ms_tick, d0_tick, d1_tick;           //tick status 
    
    //register
    always @(posedge clk)
    begin
        ms_reg <= ms_next;
        d2_reg <= d2_next;
        d1_reg <= d1_next;
        d0_reg <= d0_next;
    end
    
    //next state logic
    //0.1 second tick generator
    assign ms_next = (clr || (ms_reg == DVSR && go)) ? 0 :
                     (go) ?   ms_reg + 1 :
                              ms_reg;
    //asserts ms_tick if DVSR at max for counter                      
    assign ms_tick = (ms_reg == DVSR) ? 1'b1 : 1'b0;
    
    //0.1 sec counter
    assign d0_en   = ms_tick; //increments every time ms_tick is asserted (once a millisecond)
    assign d0_next = (clr || (d0_en && d0_reg == 9)) ? 4'b0000:
                     (d0_en) ? d0_reg + 1 : 
                               d0_reg;
    assign d0_tick = (d0_reg == 9) ? 1'b1 : 1'b0;
    
    //1 sec counter
    assign d1_en   = ms_tick & d0_tick; //increments every time ms_tick is asserted (once a millisecond)
    assign d1_next = (clr || (d1_en && d1_reg == 9)) ? 4'b0000:
                     (d1_en) ? d1_reg + 1 : 
                               d1_reg;
    assign d1_tick = (d1_reg == 9) ? 1'b1 : 1'b0;
    
    //10 sec counter
    assign d2_en   = ms_tick & d0_tick & d1_tick; //increments every time ms_tick is asserted (once a millisecond)
    assign d2_next = (clr || (d2_en && d2_reg == 9)) ? 4'b0000:
                     (d2_en) ? d2_reg + 1 : 
                               d2_reg;
    
    //output logic
    assign d0 = d0_reg;
    assign d1 = d1_reg;
    assign d2 = d2_reg;
    
endmodule
