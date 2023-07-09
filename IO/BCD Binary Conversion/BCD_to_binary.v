`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/15/2022 06:44:14 PM
// Design Name: 
// Module Name: BCD_to_binary
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


module BCD_to_binary(
    input clk, reset,
    input start,
    input [3:0] bcd1, bcd0, 
    output reg ready, done_tick,
    output [6:0] bin
    );
    
    //state declarations
    localparam [1:0] idle = 2'b00,
                     op = 2'b01,
                     done = 2'b10;
    
    //signal declaration
    reg [1:0] state_reg, state_next;
    reg [6:0] bin_reg, bin_next;
    reg [2:0] n_reg, n_next;
    reg [3:0] bcd1_reg, bcd0_reg;
    reg [3:0] bcd1_next, bcd0_next;
    wire [3:0] bcd1_temp, bcd0_temp;
    
    //FSMD state and data registers
    always @(posedge clk, posedge reset)
        if(reset)
            begin
                state_reg <= idle;
                bin_reg <= 0;
                n_reg <= 0;
                bcd1_reg <= 0;
                bcd0_reg <= 0;
            end
        else
            begin
                state_reg <= state_next;
                bin_reg <= bin_next;
                n_reg <= n_next;
                bcd1_reg <= bcd1_next;
                bcd0_reg <= bcd0_next;
            end
    
    //FSMD next state logic
    always @*
    begin
        //default values
        state_next = state_reg;
        ready = 1'b0;
        done_tick = 1'b0;
        bin_next = bin_reg;
        bcd1_next = bcd1_reg;
        bcd0_next = bcd0_reg;
        n_next = n_reg;
        
        case(state_reg)
            idle: 
                begin
                    ready = 1'b1;
                    if(start)
                        begin
                            state_next = op;
                            bcd0_next = bcd0; 
                            bcd1_next = bcd1; 
                            n_next = 3'b111;  //index to decrement in op state
                            bin_next = 0;     //binary reg to shift into
                        end
                end
            op: 
                begin
                
                bcd0_next = (bcd0_temp > 7) ? bcd0_temp - 3 : bcd0_temp;
                bcd1_next = (bcd1_temp > 7) ? bcd1_temp - 3 : bcd1_temp;
                
                bin_next = {bcd0_reg[0], bin_reg[6:1]};
                
                n_next = n_next - 1;
                if(n_next == 0)
                    state_next = done;
                end
            done: 
                begin
                    done_tick = 1'b1;
                    state_next = idle;
                end
            default: state_next = idle;
        endcase
    end
    
    
    //data path function units
    assign bcd0_temp = {bcd1_reg[0], bcd0_reg[3:1]};
    assign bcd1_temp = {1'b0, bcd1_reg[3:1]};
    
    //output
    assign bin = bin_reg;
    
endmodule
