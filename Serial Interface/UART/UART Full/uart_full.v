`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/24/2022 02:40:12 PM
// Design Name: 
// Module Name: uart_full
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


module uart_full(
    input i_clk, i_reset, 
    input [1:0] i_bd_rate,                 //bd rate select: 00 is 1200, 01 is 2400, 10 is 4800, 11 is 9600
    input [1:0] i_data_num,                //number of data bits: 00 is 6 bits, 01 is 7 bits, 10 is 8 bits
    input [1:0] i_stop_num,                //number of stop bits: 00 is 1 bit, 01 is 1.5 bits, 10 is 2 bits
    input [1:0] i_par,                     //specifies parity scheme: 00 is no parity, 01 is even parity, 10 is odd parity
    input i_rd_uart, i_wr_uart, i_rx, 
    input [7:0] i_wr_data, 
    output [2:0] o_err,                    //error active if bit 1. Bit 0 is parity error, bit 1 is frame error, bit 2 is data overrun error
    output o_tx_full, o_rx_empty, o_tx, 
    output [7:0] o_rd_data
    );
    
    parameter FIFO_W = 2;    //number of address bits in FIFO buffer
              
    wire s_tick, s_rx_done_tick, s_tx_done_tick;
    wire s_rx_full, s_tx_empty;
    wire [7:0] s_tx_fifo_out, s_rx_data_out;
                  
    baud_rate_generator_full baud_gen(.i_clk(i_clk), .i_reset(i_reset), .i_bd_rate(i_bd_rate), .o_count(), .o_baud_tick(s_tick));
    
    uart_rx_full rx_unit(.i_clk(i_clk), .i_reset(i_reset), .i_rx(i_rx), .i_baud_tick(s_tick), .i_data_num(i_data_num), .i_stop_num(i_stop_num), 
                         .i_par(i_par), .o_par_err(o_err[0]), .o_frm_err(o_err[1]), .o_rx_done_tick(s_rx_done_tick), .o_data(s_rx_data_out));
    
    FIFO_full #(.W(FIFO_W)) fifo_rx(.i_clk(i_clk), .i_reset(i_reset), .i_wr(s_rx_done_tick), .i_rd(i_rd_uart), .i_wr_data(s_rx_data_out), 
                                    .o_empty(o_rx_empty), .o_full(s_rx_full), .o_rd_data(o_rd_data));
                                         
    FIFO_full #(.W(FIFO_W)) fifo_tx(.i_clk(i_clk), .i_reset(i_reset), .i_wr(i_wr_uart), .i_rd(s_tx_done_tick), .i_wr_data(i_wr_data), 
                                    .o_empty(s_tx_empty), .o_full(o_tx_full), .o_rd_data(s_tx_fifo_out));
                                         
    uart_tx_full tx_unit(.i_clk(i_clk), .i_reset(i_reset), .i_tx_start(~s_tx_empty), .i_baud_tick(s_tick), .i_data_num(i_data_num), 
                         .i_stop_num(i_stop_num), .i_par(i_par), .i_data(s_tx_fifo_out), .o_tx_done_tick(s_tx_done_tick), .o_tx(o_tx));
    //output data
    assign o_err[2] = s_rx_done_tick && s_rx_full; //data overrun errorl. if rx FIFO full and writing next received data, overrun error active
    
endmodule
