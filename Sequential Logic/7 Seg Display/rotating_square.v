`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/07/2022 08:38:15 PM
// Design Name: 
// Module Name: rotating_square
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


module rotating_square(
    input clk, 
    input reset,
    input en,
    input cw,                //clockwise rotation if 1, counterclockwise rotation if 0
    output reg [3:0] an,
    output reg [7:0] segment
    );
    
    parameter DVSR = 50000000; //Mod-M counter for 0.5 second tick with 100MHZ clock
    
    //counter for clock frequency
    reg [31:0] ms_reg;         
    wire [31:0] ms_next;
    
    wire ms_tick;
    
    //counter for 8 rotating square states
    reg [2:0] count_reg;
    wire [2:0] count_next;
                
    always @(posedge clk, posedge reset)
        if(reset)
            begin
                ms_reg <= 0;
                count_reg <= 0;
            end
        else if (en)
            begin
                ms_reg <= ms_next;
                count_reg <= count_next;
            end
    
    //next-state logic
    
    assign ms_next = (reset || (ms_reg == DVSR && en)) ? 0 :
                     (en) ?   ms_reg + 1 :
                              ms_reg;
    //asserts ms_tick if DVSR at max for counter                      
    assign ms_tick = (ms_reg == DVSR) ? 1'b1 : 1'b0;
    
    //if clock tick and clock wise, increment. if clock tick and counter clockwise, decrement. otherwise, keep count same
    assign count_next = (ms_tick && cw)  ? count_reg + 1 : 
                        (ms_tick && ~cw) ? count_reg - 1 :
                                           count_reg;
        
    //output logic
    //an output
    always @*
        begin
            case(count_reg)
                3'b000: an = 4'b0111;
                3'b001: an = 4'b1011;
                3'b010: an = 4'b1101;
                3'b011: an = 4'b1110;
                3'b100: an = 4'b1110;
                3'b101: an = 4'b1101;
                3'b110: an = 4'b1011;
                3'b111: an = 4'b0111;
            endcase
        end
    
    //segment output
    always @*
        begin
            segment[7] = 1'b1; //DP never on for square seg display

            if(count_reg <= 3'b011) //7'b G,F,E,D,C,B,A
                segment[6:0] = 7'b0100011; //displays square in lower half
            else
                segment[6:0] = 7'b0011100; //displays square in upper half 
        end
    
            
endmodule
