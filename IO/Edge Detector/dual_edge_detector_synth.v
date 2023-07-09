`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/12/2022 10:33:09 PM
// Design Name: 
// Module Name: dual_edge_detector_synth
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


module dual_edge_detector_synth(
    input CLK100MHZ,
    input btnC, btnR, 
    output [15:0] LED
    );
    
    wire clk_div;
    
    clock_divider #(.DVSR(100000000))divider(.clk(CLK100MHZ), .reset(btnC), .en(1'b1), .tick(clk_div));
    
    assign LED[1] = clk_div;
    
//    dual_edge_detector_moore moore(.clk(clk_div), .reset(btnC), .level(btnR), .tick(LED[0]));
    dual_edge_detector_mealy mealy(.clk(clk_div), .reset(btnC), .level(btnR), .tick(LED[0]));

    
endmodule
