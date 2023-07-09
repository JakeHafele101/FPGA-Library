`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 01/10/2023 10:14:15 PM
// Design Name:
// Module Name: key_code_shift_synth
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

module key_code_shift_synth(input CLK100MHZ,
                            input btnC,
                            input PS2Data,
                            input PS2Clk,
                            output [15:0] LED,
                            output RsTx);
    
    wire s_kb_buf_empty;
    wire [8:0] s_key_code;
    wire [7:0] s_ascii_code;
    
    kb_code_shift kb_code_shift(.i_clk(CLK100MHZ), .i_reset(btnC), .i_ps2d(PS2Data), .i_ps2c(PS2Clk), .i_rd_key_code(~s_kb_buf_empty), .o_key_code(s_key_code), .o_time_out(LED[0]), .o_kb_buf_empty(s_kb_buf_empty));
    
    key_to_ascii_shift key_to_ascii_shift(.i_key_code(s_key_code), .o_ascii_code(s_ascii_code));
    
    uart uart(.i_clk(CLK100MHZ), .i_reset(btnC), .i_rd_uart(1'b0), .i_wr_uart(~s_kb_buf_empty), .i_rx(1'b1), .i_wr_data(s_ascii_code),
    .o_tx_full(), .o_rx_empty(), .o_tx(RsTx), .o_rd_data());
    
endmodule
