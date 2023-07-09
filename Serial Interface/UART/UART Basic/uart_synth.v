`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/22/2022 02:45:01 PM
// Design Name: 
// Module Name: uart_synth
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


module uart_synth(
    input CLK100MHZ,
    input btnL, btnC,
    input RsRx,
    output RsTx,
    output [15:0] LED, 
    output [3:0] an,
    output dp,
    output [6:0] seg
    );
    
    parameter DBIT = 8,      //bits of data in word
              SB_TICK = 16,  //ticks for stop bit. 16 = 1 bit, 24 for 1.5 bits, 32 for 2 bits
              DVSR = 326,     //counter for baud rate of 10 (T/BAUD)
              DVSR_BIT = 12,  //number of bits for DVSR counter for baud rate tick generator
              FIFO_W = 2;    //number of address bits in FIFO buffer (4 words)
              
    wire btnDB;
    wire [DBIT-1:0] rec_data, rec_data_inc;
              
    debounce dbL(.clk(CLK100MHZ), .reset(btnC), .switch(btnL), .db(), .tick(btnDB));
            
    uart #(.DBIT(DBIT), .SB_TICK(SB_TICK), .DVSR(DVSR), .DVSR_BIT(DVSR_BIT), .FIFO_W(FIFO_W))
         uart(.i_clk(CLK100MHZ), .i_reset(btnC), .i_rd_uart(btnDB), .i_wr_uart(btnDB), .i_rx(RsRx), 
              .i_wr_data(rec_data_inc), .o_tx_full(LED[1]), .o_rx_empty(LED[0]), .o_tx(RsTx), 
              .o_rd_data(rec_data));
              
    seven_seg_mux segment(.clk(CLK100MHZ), .reset(btnC), .duty_cycle(4'b1000), .hex3(rec_data_inc[7:4]), .hex2(rec_data_inc[3:0]), 
                          .hex1(rec_data[7:4]), .hex0(rec_data[3:0]), .dp(4'b0000), .an_en(4'b1111), .seg_out({dp, seg}), .an_out(an));
    
    assign rec_data_inc = rec_data + 1;
    
endmodule
