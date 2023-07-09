`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/13/2022 12:35:14 AM
// Design Name: 
// Module Name: debounce
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


module debounce(
    input clk, reset,
    input switch,
    output reg db
    );
    
    parameter DVSR = 2000000; //counter for 20 ms tick
    
    localparam [1:0] zero = 2'b00,
                     hold_one = 2'b01, 
                     one  = 2'b10,
                     hold_zero  = 2'b11;
    
    reg [1:0] state_reg, state_next;
    
    wire ms_tick;

    clock_divider #(.DVSR(DVSR))divider(.clk(clk), .reset(reset), .en(1'b1), .tick(ms_tick));

    //D FF 
    always @(posedge clk, posedge reset)
        if(reset)
            state_reg = zero;
        else
            state_reg = state_next;
            
    //Next state logic and output logic
    always @*
        begin
            db = 1'b0;  //default off
            
            case(state_reg)
                zero: state_next = switch ? hold_one : zero;
                hold_one: 
                    begin
                        db = 1'b1;
                        state_next = ms_tick ? one : hold_one;
                    end
                one: 
                    begin
                        db = 1'b1;
                        state_next = switch ? one : hold_zero;
                    end
                hold_zero: state_next = ms_tick ? zero : hold_zero;
            endcase
        end
    
endmodule
