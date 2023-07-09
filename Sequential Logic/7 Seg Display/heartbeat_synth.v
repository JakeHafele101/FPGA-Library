`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/11/2022 03:48:41 PM
// Design Name: 
// Module Name: heartbeat_synth
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


module heartbeat_synth(
    input CLK100MHZ,
    input btnC,
    input [15:0] sw,
    output [15:0] LED,
    output [3:0] an,
    output dp,
    output [6:0] seg
    );
    
    wire [3:0] an_en;
    wire [3:0] line;
    
    assign LED[0] = sw[0];
    
    heartbeat heartbeat(.clk(CLK100MHZ), .reset(btnC), .en(sw[0]), .an_en(an_en), .line(line));
    
    seven_seg_heartbeat_mux segment_heart(.clk(CLK100MHZ), .reset(btnC), .line(line), .an_en(an_en), .an(an), .segment({dp, seg}));
    
endmodule
