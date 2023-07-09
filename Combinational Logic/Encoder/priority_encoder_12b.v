`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/02/2022 07:53:32 PM
// Design Name: 
// Module Name: priority_encoder_12b
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


module priority_encoder_12b(
    input [11:0] req,
    output reg [3:0] out
    );
    
    always @*
        begin
            casex(req)
                12'b1???????????: out = 4'b1011; //11
                12'b01??????????: out = 4'b1010; //10
                12'b001?????????: out = 4'b1001; //9
                12'b0001????????: out = 4'b1000; //8
                12'b00001???????: out = 4'b0111; //7
                12'b000001??????: out = 4'b0110; //6
                12'b0000001?????: out = 4'b0101; //5
                12'b00000001????: out = 4'b0100; //4
                12'b000000001???: out = 4'b0011; //3
                12'b0000000001??: out = 4'b0010; //2
                12'b00000000001?: out = 4'b0001; //1
                12'b000000000001: out = 4'b0000; //0
                default: out = 4'b1111; //no 1 bit, set to 15 for F on seven seg disp
            endcase
        end
    
endmodule
