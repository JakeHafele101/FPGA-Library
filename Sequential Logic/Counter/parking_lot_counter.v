`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/14/2022 08:52:11 PM
// Design Name: 
// Module Name: parking_lot_counter
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


module parking_lot_counter(
    input clk, reset,
    input a,
    input b,
    output reg enter,
    output reg exit
    );
    
    //assigns state names to bit values for case statement
    localparam [2:0] open = 3'b000, 
                     enter_a = 2'b001, 
                     enter_ab  = 3'b010, 
                     enter_b = 3'b011,
                     exit_b = 3'b100,
                     exit_ab = 3'b101,
                     exit_a = 3'b110;
                     
    reg [2:0] state_reg, state_next;
    
    //D FF 
    always @(posedge clk, posedge reset)
        if(reset)
            state_reg = open;
        else
            state_reg = state_next;
            
    //next state and output logic
    always @*   
        begin
            //assign default values
            enter = 1'b0;
            exit = 1'b0;
            state_next = state_reg;
            case(state_reg)
                open: 
                    if(~a && b)
                        state_next = exit_b;
                    else if(a && ~b)
                        state_next = enter_a;
                enter_a: 
                    if(~a)
                        state_next = open;
                    else if(a && b)
                        state_next = enter_ab;
                enter_ab: 
                    if(a && ~b)
                        state_next = enter_a;
                    else if(~a && b)
                        state_next = enter_b;
                    else if(~a && ~b)
                        state_next = open;
                
                enter_b: 
                    if(a && b)
                        state_next = enter_ab;
                    else if(~a && ~b)
                        begin
                            enter = 1'b1;
                            state_next = open;
                        end
                    else if(a && ~b)
                        state_next = open;
                exit_b: 
                    if(~b)
                        state_next = open;
                    else if(a && b)
                        state_next = exit_ab;
                exit_ab: 
                    if(~a && b)
                        state_next = exit_b;
                    else if(a && ~b)
                        state_next = exit_a;
                    else if(~a && ~b)
                        state_next = open;
                exit_a: 
                    if(a && b)
                        state_next = exit_ab;
                    else if(~a && ~b)
                        begin
                            exit = 1'b1;
                            state_next = open;
                        end
                    else if(~a && b)
                        state_next = open;
                default: state_next = open;
            endcase
        end
    
endmodule
