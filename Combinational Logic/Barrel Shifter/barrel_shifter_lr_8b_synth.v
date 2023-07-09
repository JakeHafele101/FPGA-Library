`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/02/2022 05:55:46 PM
// Design Name: 
// Module Name: barrel_shifter_lr_8b_synth
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


module barrel_shifter_lr_8b_synth(
    input [15:0] sw,       
    output [15:0] LED
    );
    
    assign LED[7:0] = sw[7:0];
    
    barrel_shifter_lr_8b shifter_lr(.a(sw[7:0]), .lr(sw[8]), .amt(sw[11:9]), .y(LED[15:8]));
//    barrel_shifter_r_8b shifter_lr(.a(sw[7:0]), .lr(sw[8]), .amt(sw[11:9]), .y(LED[15:8]));

    
endmodule
