`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/12/2022 08:44:14 PM
// Design Name: 
// Module Name: dual_edge_detector_moore
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


module dual_edge_detector_moore(
    input clk, reset,
    input level,
    output reg tick
    );
    
    //assigns state names to bit values for case statement
    localparam [1:0] zero = 2'b00, 
                     rise = 2'b01, 
                     one  = 2'b10, 
                     fall = 2'b11;
                     
    reg [1:0] state_reg, state_next;
                 
    //D FF 
    always @(posedge clk, posedge reset)
        if(reset)
            state_reg = zero;
        else
            state_reg = state_next;
            
    //Next state logic and output logic
    always @*
        begin
            tick = 1'b0;  //default off since rising/falling edge will happen less often
            case(state_reg)
                zero: state_next = level ? rise : state_reg;
                rise:
                    begin
                        tick = 1'b1;
                        state_next = level ? one : fall;
                    end
                one: state_next = level ? state_reg : fall;
                fall: 
                    begin
                        tick = 1'b1;
                        state_next = level ? rise : zero;
                    end
            endcase
        end
        
endmodule
