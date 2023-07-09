`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/01/2023 08:44:03 PM
// Design Name: 
// Module Name: uart_full_synth
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


module uart_full_synth(
    input CLK100MHZ,
    input btnL, btnC,
    input RsRx,
    input [15:0] sw,
    output RsTx,
    output [15:0] LED, 
    output [3:0] an,
    output dp,
    output [6:0] seg
    );
    
    parameter FIFO_W = 2;    //number of address bits in FIFO buffer (4 words)
              
    wire btnDB;
    wire [7:0] rec_data, rec_data_inc;
    wire [2:0] err;
              
    assign LED[7:0] = sw[7:0];
              
    debounce dbL(.clk(CLK100MHZ), .reset(btnC), .switch(btnL), .db(), .tick(btnDB));
        
    
    uart_full #(.FIFO_W(FIFO_W)) uart(.i_clk(CLK100MHZ), .i_reset(btnC), .i_bd_rate(sw[1:0]), .i_data_num(sw[3:2]),.i_stop_num(sw[5:4]), .i_par(sw[7:6]),
                                      .i_rd_uart(btnDB), .i_wr_uart(btnDB), .i_rx(RsRx), .i_wr_data(rec_data_inc), .o_err(LED[15:13]), 
                                      .o_tx_full(LED[12]), .o_rx_empty(LED[11]), .o_tx(RsTx), .o_rd_data(rec_data));
              
    seven_seg_mux segment(.clk(CLK100MHZ), .reset(btnC), .duty_cycle(4'b1000), .hex3(rec_data_inc[7:4]), .hex2(rec_data_inc[3:0]), 
                          .hex1(rec_data[7:4]), .hex0(rec_data[3:0]), .dp(4'b0000), .an_en(4'b1111), .seg_out({dp, seg}), .an_out(an));
    
    //output data
    assign rec_data_inc = rec_data + 1;
endmodule
