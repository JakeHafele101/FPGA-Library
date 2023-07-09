`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/12/2022 01:31:41 PM
// Design Name: 
// Module Name: stack_synth
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


module stack_synth(
    input CLK100MHZ,
    input btnC,btnR, btnL,
    input [15:0] sw,
    output [15:0] LED,
    output [3:0] an,
    output dp,
    output [6:0] seg
    );
    
    wire [3:0] pop_data;
    wire tick;
    
    assign LED[3:0] = sw[3:0];
    assign LED[6] = tick;
    
    clock_divider clock(.clk(CLK100MHZ), .reset(btnC), .en(1'b1), .tick(tick));
    
    stack stack(.clk(tick), .reset(btnC), .push(btnR), .pop(btnL), .push_data(sw[3:0]), .empty(LED[4]), .full(LED[5]), .pop_data(pop_data));
    
    seven_seg_mux segment(.clk(CLK100MHZ), .reset(btnC), .duty_cycle(4'b1000), .hex3(pop_data), .hex2(4'hF), .hex1(4'hF), .hex0(sw[3:0]),
                          .dp(4'b0000), .an_en(4'b1001), .seg_out({dp, seg}), .an_out(an));
    
endmodule
