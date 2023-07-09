`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/09/2022 12:29:46 AM
// Design Name: 
// Module Name: heartbeat
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


module heartbeat(
    input clk, 
    input reset,
    input en,
    output reg [3:0] an_en,    //if 1 on, if 0 off
    output reg [3:0] line
    );
    
    parameter DVSR = 1388889; //Mod-M counter for 72 Hz heartbeat frequency
    
    //counter for clock frequency
    reg [31:0] ms_reg;
    wire [31:0] ms_next;
    
    wire ms_tick;
    
    //counter for 8 rotating square states
    reg [1:0] count_reg;
    wire [1:0] count_next;
                
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
    assign count_next = (ms_tick && count_reg == 2) ? 0 : 
                                          (ms_tick) ? count_reg + 1 : 
                                                      count_reg;
        
    //output logic
    //an_en to seg mux, line to determine if on left or right side for each of the 4 displays
    always @*
        begin
            case(count_reg)
                2'b00:  //state 1
                    begin
                        an_en = 4'b0110;    
                        line = 4'b0100;     //bit 3 and 0 are don't cares, an not enabled
                    end
                2'b01:  //state 2
                    begin
                        an_en = 4'b0110;    
                        line = 4'b0010;     //bit 3 and 0 are don't cares, an not enabled
                    end
                default: //state 3 + default coverage
                    begin
                        an_en = 4'b1001;    
                        line = 4'b0001;     //bit 2 and 1 are don't cares, an not enabled
                    end
            endcase
        end

endmodule
