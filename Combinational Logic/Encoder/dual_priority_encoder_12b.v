`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/02/2022 07:34:01 PM
// Design Name: 
// Module Name: dual_priority_encoder_12b
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


module dual_priority_encoder_12b(
    input [11:0] req,
    output [3:0] first, //bit position of first 1 in req
    output [3:0] second //bit posisition of second 1 in req
    );
    
    reg [11:0] req_second;
    
    //priority encoder to find first output
    priority_encoder_12b encoder_first(.req(req), .out(first));
    
    //priority encoder to find second output with most significant 1 set to 0
    priority_encoder_12b encoder_second(.req(req_second), .out(second));
    
    always @*
        begin
                
            req_second = req;
            
            if(first != 4'b1111)
                req_second[first] = 0;
        
        end
    
endmodule
