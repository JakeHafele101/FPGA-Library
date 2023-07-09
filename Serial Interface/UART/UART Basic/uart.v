`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/21/2022 02:11:39 PM
// Design Name: 
// Module Name: uart
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


module uart(
    input i_clk, i_reset, 
    input i_rd_uart, i_wr_uart, i_rx, 
    input [7:0] i_wr_data, 
    output o_tx_full, o_rx_empty, o_tx, 
    output [7:0] o_rd_data
    );
    
    parameter DBIT = 8,      //bits of data in word
              SB_TICK = 16,  //ticks for stop bit. 16 = 1 bit, 24 for 1.5 bits, 32 for 2 bits
              DVSR = 326,    //counter for baud rate of 19,200
              DVSR_BIT = 9,  //number of bits for DVSR counter for baud rate tick generator
              FIFO_W = 2;    //number of address bits in FIFO buffer
              
    wire s_tick, s_rx_done_tick, s_tx_done_tick;
    wire s_tx_empty;
    wire [DBIT-1:0] s_tx_fifo_out, s_rx_data_out;
              
    baud_rate_generator #(.M(DVSR), .N(DVSR_BIT))baud_gen(.i_clk(i_clk), .i_reset(i_reset), .o_count(), .o_baud_tick(s_tick));
    
    uart_rx #(.DBIT(DBIT), .SB_TICK(SB_TICK)) rx(.i_clk(i_clk), .i_reset(i_reset), .i_rx(i_rx), .i_s_tick(s_tick), 
                                                                .o_rx_done_tick(s_rx_done_tick), .o_data(s_rx_data_out));
    
    FIFO #(.B(DBIT), .W(FIFO_W)) fifo_rx(.i_clk(i_clk), .i_reset(i_reset), .i_wr(s_rx_done_tick), .i_rd(i_rd_uart), .i_wr_data(s_rx_data_out), 
                                         .o_empty(o_rx_empty), .o_full(), .o_rd_data(o_rd_data));
                                         
    FIFO #(.B(DBIT), .W(FIFO_W)) fifo_tx(.i_clk(i_clk), .i_reset(i_reset), .i_wr(i_wr_uart), .i_rd(s_tx_done_tick), .i_wr_data(i_wr_data), 
                                         .o_empty(s_tx_empty), .o_full(o_tx_full), .o_rd_data(s_tx_fifo_out));
                                         
    uart_tx #(.DBIT(DBIT), .SB_TICK(SB_TICK)) tx(.i_clk(i_clk), .i_reset(i_reset), .i_tx_start(~s_tx_empty), .i_s_tick(s_tick), .i_data(s_tx_fifo_out), 
                                                 .o_tx_done_tick(s_tx_done_tick), .o_tx(o_tx));
    
endmodule
