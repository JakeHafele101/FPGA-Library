`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/04/2022 09:59:50 PM
// Design Name: 
// Module Name: square_wave
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

//
module square_wave(
    input  clk,      //100MHZ clk on Basys 3 Artix 7, 10ns period
    input  reset,
    input en,
    input  [3:0] m,  //m*100ns is on interval, unsigned integer. on for m*(10 clock periods)
    input  [3:0] n,  //n*100ns is off interval, unsigned integer. off for n*(10 clock periods)
    output out      // output square wave
    );
        
    //current state and next state register for square wave output
    reg r_reg;
    
    //register count for clock periods
    reg [7:0] r_count;
    
    //D FF
    always @(posedge clk, posedge reset)
        if(reset)
            begin
                r_reg <= 0;
                r_count <= 0;
            end
        else if (en)
            begin
                r_count <= r_count + 1;
            end             
            
    //next-state logic
    always @*
        if(r_reg && (r_count == m * 10)) //if square wave is 1 and m period count at max up count, set to 0 and reset counter
            begin
                r_reg = 1'b0;
                r_count = 0;
            end
        else if(~r_reg && (r_count == n * 10)) //if square wave is 0 and n period count at max down count, set to 1 and reset counter
            begin
                r_reg = 1'b1;
                r_count = 0;
            end

    //output logic
    assign out = r_reg;
    
endmodule
