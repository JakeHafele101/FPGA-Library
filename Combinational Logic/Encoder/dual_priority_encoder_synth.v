`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/03/2022 12:07:25 AM
// Design Name: 
// Module Name: dual_priority_encoder_synth
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


module dual_priority_encoder_synth(
    input [15:0] sw,
    input CLK100MHZ,
    input btnC,
    output [15:0] LED,
    output [6:0] seg,
    output dp,
    output [3:0] an
    );
    
    assign LED[11:0] = sw[11:0]; 
    
    wire [3:0] first, second;
    
    dual_priority_encoder_12b encoder(.req(sw[11:0]), .first(first), .second(second));
    
    seven_seg_mux segment_display(.clk(CLK100MHZ), .reset(btnC), .hex3(4'hF), .hex2(4'hF), 
                                  .hex1(first), .hex0(second), .dp(4'b1111), .an_en(4'b0011), 
                                  .seg_out({dp, seg}), .an_out(an));
   
endmodule
