`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/01/2023 09:31:58 PM
// Design Name: 
// Module Name: enhanced_stopwatch
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


module enhanced_stopwatch(
    input clk,                    //input clock, 100MHZ on Basys 3
    input go,                     //go signal to start/stop counter
    input clr,                    //clr signal to reset counter
    input up,                     //if 1, count up. if 0, count down
    output [3:0] d3, d2, d1, d0   //output for minute, second, and millisecond increments on counter
    );
    
    parameter DVSR = 10000000; //Mod-M counter for 0.1 second tick with 100MHZ clock
    
    reg  [31:0] ms_reg;         
    wire [31:0] ms_next;
    
    reg  [3:0] d3_reg, d2_reg, d1_reg, d0_reg;         //BCD second registers
    wire [3:0] d3_next, d2_next, d1_next, d0_next;     //BCD second next value (stay same, count up, roll over from 9 to 0)
    
    wire d3_en, d2_en, d1_en, d0_en;                   //Enable status of if 10, 1, and 0.1 second should count
    
    wire ms_tick, d0_tick, d1_tick, d2_tick;           //tick status 
    
    //register
    always @(posedge clk)
    begin
        ms_reg <= ms_next;
        d3_reg <= d3_next;
        d2_reg <= d2_next;
        d1_reg <= d1_next;
        d0_reg <= d0_next;
    end
    
    //next state logic
    //0.1 second tick generator
    assign ms_next = (clr || (ms_reg == DVSR && go)) ? 4'b0000 :
                     (go) ?   ms_reg + 1 :
                              ms_reg;
    //asserts ms_tick if DVSR at max for counter                      
    assign ms_tick = (ms_reg == DVSR && go) ? 1'b1 : 1'b0;
    
    //0.1 sec counter (0 to 9)
    assign d0_en   = ms_tick; //increments every time ms_tick is asserted (once a millisecond)
    assign d0_next = (clr || (d0_en && up && d0_reg == 9)) ? 4'b0000: 
                     (d0_en && ~up  && d0_reg == 0)        ? 4'b1001:
                     (d0_en && up)  ?  d0_reg + 1 :   
                     (d0_en && ~up) ?  d0_reg - 1 :   
                                       d0_reg;
    assign d0_tick = ((d0_reg == 9 && up) || (d0_reg == 0 && ~up)) ? 1'b1 : 1'b0; //tick asserted if 9 and counting up or 0 and counting down
    
    //1 sec counter (0 to 9)
    assign d1_en   = ms_tick & d0_tick; //increments every time ms_tick is asserted (once a millisecond)
    assign d1_next = (clr || (d1_en && up && d1_reg == 9)) ? 4'b0000: 
                     (d1_en && ~up  && d1_reg == 0)        ? 4'b1001:
                     (d1_en && up)  ?  d1_reg + 1 :   
                     (d1_en && ~up) ?  d1_reg - 1 :   
                                       d1_reg;
    assign d1_tick = ((d1_reg == 9 && up) || (d1_reg == 0 && ~up)) ? 1'b1 : 1'b0; //tick asserted if 9 and counting up or 0 and counting down
    
    //10 sec counter (0 to 5)
    assign d2_en   = ms_tick && d0_tick && d1_tick; //increments every time ms_tick is asserted (once a millisecond)
    assign d2_next = (clr || (d2_en && up && d2_reg == 5)) ? 4'b0000: 
                     (d2_en && ~up  && d2_reg == 0)        ? 4'b0101:
                     (d2_en && up)  ?  d2_reg + 1 :   
                     (d2_en && ~up) ?  d2_reg - 1 :   
                                       d2_reg;
    assign d2_tick = ((d2_reg == 5 && up) || (d2_reg == 0 && ~up)) ? 1'b1 : 1'b0; //tick asserted if 9 and counting up or 0 and counting down

    //1 minute counter (0 to 9)
    assign d3_en   = ms_tick && d0_tick && d1_tick && d2_tick; //increments every time ms_tick is asserted (once a millisecond)
    assign d3_next = (clr || (d3_en && up && d3_reg == 9)) ? 4'b0000: 
                     (d3_en && ~up  && d3_reg == 0)        ? 4'b1001:
                     (d3_en && up)  ?  d3_reg + 1 :   
                     (d3_en && ~up) ?  d3_reg - 1 :   
                                       d3_reg;                               
    
    //output logic
    assign d0 = d0_reg;
    assign d1 = d1_reg;
    assign d2 = d2_reg;
    assign d3 = d3_reg;
    
endmodule