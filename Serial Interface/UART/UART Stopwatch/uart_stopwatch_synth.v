`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/03/2023 03:51:06 PM
// Design Name: 
// Module Name: uart_stopwatch_synth
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


module uart_stopwatch_synth(
    input CLK100MHZ,
    input btnC,
    input RsRx,
    input [15:0] sw,
    output RsTx,
    output [15:0] LED, 
    output [3:0] an,
    output dp,
    output [6:0] seg
    );
    
    parameter FIFO_W = 8;
              
    wire [7:0] s_rd_ascii, s_wr_ascii;
    wire s_rd_uart, s_wr_uart;
    wire s_tx_full, s_rx_empty;
    
    wire s_go, s_clr, s_up, s_tx_start_tick;
    wire [3:0] s_d3, s_d2, s_d1, s_d0;
                                                    
    assign LED[7:0] = sw[7:0];
                                                    
    uart_full #(.FIFO_W(FIFO_W)) uart(.i_clk(CLK100MHZ), .i_reset(btnC), .i_bd_rate(sw[1:0]), .i_data_num(sw[3:2]),.i_stop_num(sw[5:4]), .i_par(sw[7:6]),
                                      .i_rd_uart(~s_rx_empty), .i_wr_uart(s_wr_uart), .i_rx(RsRx), .i_wr_data(s_wr_ascii), .o_err(LED[15:13]), 
                                      .o_tx_full(s_tx_full), .o_rx_empty(s_rx_empty), .o_tx(RsTx), .o_rd_data(s_rd_ascii));
    
    enhanced_stopwatch_receive_interface recieve_ascii(.i_clk(CLK100MHZ), .i_reset(btnC), .i_ascii(s_rd_ascii), .i_rd_ascii(~s_rx_empty), .o_go(s_go), 
                                                       .o_clr(s_clr), .o_up(s_up), .o_tx_start_tick(s_tx_start_tick));
                                                       
    enhanced_stopwatch stopwatch(.clk(CLK100MHZ), .go(s_go), .clr(s_clr), .up(s_up), .d3(s_d3), .d2(s_d2), .d1(s_d1), .d0(s_d0));
    
    enhanced_stopwatch_transmit_interface transmit_ascii(.i_clk(CLK100MHZ), .i_reset(btnC), .i_start(s_tx_start_tick), .i_d3(s_d3), .i_d2(s_d2), 
                                                         .i_d1(s_d1), .i_d0(s_d0), .o_ascii(s_wr_ascii), .o_fifo_wr(s_wr_uart));
              
    seven_seg_mux segment(.clk(CLK100MHZ), .reset(btnC), .duty_cycle(4'b1000), .hex3(s_d3), .hex2(s_d2), .hex1(s_d1), .hex0(s_d0), 
                          .dp(4'b1010), .an_en(4'b1111), .seg_out({dp, seg}), .an_out(an));
    
endmodule
