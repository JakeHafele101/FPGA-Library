`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/13/2022 07:17:56 PM
// Design Name: 
// Module Name: debounce_synth
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


module debounce_synth(
    input CLK100MHZ,
    input btnC, btnR,
    input [15:0] sw,
    output [15:0] LED, 
    output [3:0] an,
    output dp,
    output [6:0] seg
    );
    
    
    wire db;
    wire tick, tick_db;
    wire [7:0] count_db, count;
    
    //instantiate debounce circuit and dual edge detector/counter. 20 ns debounce!
    debounce debounce(.clk(CLK100MHZ), .reset(btnC), .switch(btnR), .db(db));
    
    rising_edge_detector_mealy mealy_edge_db(.clk(CLK100MHZ), .reset(btnC), .level(db), .tick(tick_db));
    
    counter_8b counter_db(.clk(CLK100MHZ), .reset(btnC), .en(tick_db), .q(count_db));
    
    //instantiate dual edge detector and counter WITHOUT debounce circuit
    rising_edge_detector_mealy mealy_edge(.clk(CLK100MHZ), .reset(btnC), .level(btnR), .tick(tick));
    
    counter_8b counter(.clk(CLK100MHZ), .reset(btnC), .en(tick), .q(count));
    
    seven_seg_mux segment(.clk(CLK100MHZ), .reset(btnC), .duty_cycle(4'b1000), .hex3(count_db[7:4]), .hex2(count_db[3:0]), .hex1(count[7:4]), .hex0(count[3:0]),
                          .dp(4'b0000), .an_en(4'b1111), .seg_out({dp, seg}), .an_out(an));
    
    
endmodule
