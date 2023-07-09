`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/15/2022 04:07:06 PM
// Design Name: 
// Module Name: debounce_FSMD_synth
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


module debounce_FSMD_synth(
    input CLK100MHZ,
    input btnC, btnR,
    input [15:0] sw,
    output [15:0] LED, 
    output [3:0] an,
    output dp,
    output [6:0] seg
    );
    
    
    wire db_level, db_tick;
    wire tick;
    wire [7:0] count_db, count;
    
    //instantiate debounce circuit and dual edge detector/counter. 20 ns debounce!
    debounce_FSMD debounce(.clk(CLK100MHZ), .reset(btnC), .sw(btnR), .db_level(db_level), .db_tick(db_tick));
        
    counter_8b counter_db(.clk(CLK100MHZ), .reset(btnC), .en(db_tick), .q(count_db));
    
    //instantiate dual edge detector and counter WITHOUT debounce circuit
    rising_edge_detector_mealy mealy_edge(.clk(CLK100MHZ), .reset(btnC), .level(btnR), .tick(tick));
    
    counter_8b counter(.clk(CLK100MHZ), .reset(btnC), .en(tick), .q(count));
    
    seven_seg_mux segment(.clk(CLK100MHZ), .reset(btnC), .duty_cycle(4'b1000), .hex3(count_db[7:4]), .hex2(count_db[3:0]), .hex1(count[7:4]), .hex0(count[3:0]),
                          .dp(4'b0000), .an_en(4'b1111), .seg_out({dp, seg}), .an_out(an));
endmodule
