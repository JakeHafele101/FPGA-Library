`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/03/2022 08:26:45 PM
// Design Name: 
// Module Name: floating_greater_synth
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


module floating_greater_synth(
    input [15:0] sw,
    output [15:0] LED
    );
    
    wire [12:0] a = {sw[7:0] , 5'b00000};
    wire [12:0] b = {sw[15:8], 5'b00000};
    
    floating_greater greater(.a(a), .b(b), .gt(LED[0]));
    
endmodule
