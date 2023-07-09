`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/06/2022 06:58:02 PM
// Design Name: 
// Module Name: pwm_4b
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


module pwm_4b(
    input clk,
    input reset,
    input [3:0] w,   //unsigned integer, duty cycle is w/16 for amount positive (1) of pulse
    output pwm       //output pwm signal, varying duty cycle dependent on w
    );
    
    reg  [3:0] count_reg;
    wire [3:0] count_next;
    
    reg  pwm_reg;
    wire pwm_next;
    
    //register
    always @(posedge clk, posedge reset)
    begin
        if(reset)
            begin
                count_reg = 0;
                pwm_reg = 0;
            end
        else
            begin
                count_reg <= count_next;
                pwm_reg <= pwm_next;
            end
    end
    
    //next state logic
    //if counter at max (15), reset to 0
    assign count_next = (count_reg == 15) ? 4'b0000 : count_reg + 1;
    
    //if pwm signal at max number for logic 1 output, set to 0
    assign pwm_next   = (count_reg == 15)      ? 1'b0 :  //if count at max, reset to 1
                        (count_reg >= 15 - w)  ? 1'b1 :  //if count greater or equal to w, update pwm signal to 0
                                                 1'b0;   //otherwise if less than w, update 1
    //output logic
    assign pwm = pwm_reg;
    
endmodule
