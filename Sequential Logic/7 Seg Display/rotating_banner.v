`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/11/2022 04:31:53 PM
// Design Name: 
// Module Name: rotating_banner
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


module rotating_banner(
    input clk,
    input reset,
    input en,
    input dir,            //if 0, rotate right. if 1, rotate left
    input [31:0] m, //10 hex value message to scroll on 4 seven seg display
    output reg [15:0] hex
    );
    
    parameter DVSR = 50000000; //Mod-M counter for 5 Hz shift frequency
    
    //counter for clock frequency
    reg [31:0] ms_reg;
    wire [31:0] ms_next;
    
    wire ms_tick;
    
    //counter for 8 rotating square states
    reg [2:0] count_reg;                       //count to shift hex values X times based on entry position
    wire [2:0] count_next;
    
    reg [31:0] reverse;
    reg [31:0] s0, s1, s2;
                
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
                                                  (en) ? ms_reg + 1 :
                                                         ms_reg;
    //asserts ms_tick if DVSR at max for counter                      
    assign ms_tick = (ms_reg == DVSR) ? 1'b1 : 1'b0;
    
    //if clock tick and clock wise, increment. if clock tick and counter clockwise, decrement. otherwise, keep count same
    assign count_next = (ms_tick && dir)  ? count_reg - 1 : 
                        (ms_tick && ~dir) ? count_reg + 1 :
                                            count_reg;
        
    //output logic
    
    always @*
        begin
            case(count_reg)
                3'b000: hex = m[31:16]; //no shift
                3'b001: hex = m[27:12];
                3'b010: hex = m[23:8];
                3'b011: hex = m[19:4];
                3'b100: hex = m[15:0];
                3'b101: hex = {m[11:0], m[31:28]};
                3'b110: hex = {m[7:0], m[31:24]};
                3'b111: hex = {m[3:0], m[31:20]};
            endcase
        end
    
endmodule
