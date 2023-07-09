`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/11/2022 03:00:29 PM
// Design Name: 
// Module Name: seven_seg_heartbeat_mux
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


module seven_seg_heartbeat_mux(
    input clk,
    input reset,
    input [3:0] line,                    //determines if segment display will be upper (1) or lower (0) square
    input [3:0] an_en,           //enable input determining which seg displays on (should only be 1)
    output reg [3:0] an,         //output an for FPGA
    output reg [7:0] segment     //output seg for FPGA
    );
    
    parameter N = 18;

    reg [N-1:0] q_reg;
    wire [N-1:0] q_next;
    
    reg line_next;
            
    //Register
    always @(posedge clk, posedge reset)
        if(reset)
            q_reg <= 0;
        else
            q_reg <= q_next;
    
    //next-state logic
    assign q_next = q_reg + 1; //if at max value, addition jumps back to 0
    
    //output logic
    always @*
    begin
        case(q_reg[N-1:N-2]) //Checks two most significant bits of counter for case selection
            2'b00: 
                begin
                    an = ~(4'b0001 & an_en);
                    line_next = line[0];
                end
            2'b01:
                begin
                    an = ~(4'b0010 & an_en);
                    line_next = line[1];
                end
            2'b10: 
                begin
                    an = ~(4'b0100 & an_en);
                    line_next = line[2];
                end
            2'b11:
                begin
                    an = ~(4'b1000 & an_en);
                    line_next = line[3];
                end
        endcase
    end
    
    always @*
        begin
            case(line_next) //7'b G,F,E,D,C,B,A
                1'b0: segment[6:0] = 7'b1001111; //displays line on left side of seg
                1'b1: segment[6:0] = 7'b1111001; //displays line on right side of seg
            endcase
            segment[7] = 1'b1; //DP never on for square seg display
        end
    //output logic
    
endmodule
