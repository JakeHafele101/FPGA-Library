`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/14/2022 09:43:08 PM
// Design Name: 
// Module Name: parking_lot_counter_synth
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


module parking_lot_counter_synth(
    input CLK100MHZ,
    input btnL, btnC, btnR,
    output [3:0] an,
    output dp,
    output [6:0] seg
    );
    
    wire enter, exit;
    wire [3:0] count;
    
    parking_lot_counter lot(.clk(CLK100MHZ), .reset(btnC), .a(btnL), .b(btnR), .enter(enter), .exit(exit));
        
    up_down_counter_4b counter(.clk(CLK100MHZ), .reset(btnC), .inc(enter), .dec(exit), .q(count));
    
    seven_seg_mux segment(.clk(CLK100MHZ), .reset(btnC), .duty_cycle(4'b1000), .hex3(4'hF), .hex2(4'hF), .hex1(4'hF), .hex0(count),
                          .dp(4'b0000), .an_en(4'b0001), .seg_out({dp, seg}), .an_out(an));
    
endmodule
