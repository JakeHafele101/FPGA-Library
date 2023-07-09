`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/10/2023 02:01:33 PM
// Design Name: 
// Module Name: kb_code_hold
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


module kb_code_hold(
    input i_clk, i_reset,
    input i_ps2d, i_ps2c, i_rd_key_code, 
    output [7:0] o_key_code, 
    output o_kb_buf_empty
    );
    
    parameter FIFO_W = 2; //2^W word size for FIFO buffer
    
    //state definition
    localparam [1:0] idle     = 2'b00, 
                     get_code = 2'b01,
                     wait_break = 2'b10;
               
    localparam [7:0] BRK = 8'hf0; //BRK code after key released
               
    //signal declaraction
    reg [1:0] s_state_reg, s_state_next;
    
    wire [7:0] s_key_code;
    wire s_scan_done_tick;
    
    reg s_got_code_tick;
    
    //ps2 receiver
    ps2_rx ps2_rx(.i_clk(i_clk), .i_reset(i_reset), .i_ps2d(i_ps2d), .i_ps2c(i_ps2c), .i_rx_en(1'b1), .o_rx_done_tick(s_scan_done_tick), .o_data(s_key_code));
    
    //FIFO buffer
    FIFO #(.B(8), .W(FIFO_W)) fifo_rx(.i_clk(i_clk), .i_reset(i_reset), .i_wr(s_got_code_tick), .i_rd(i_rd_key_code), .i_wr_data(s_key_code), 
                                         .o_empty(o_kb_buf_empty), .o_full(), .o_rd_data(o_key_code));
    
    //state register
    always @(posedge i_clk, posedge i_reset)
        if (i_reset)
            s_state_reg <= idle;
        else
            s_state_reg <= s_state_next;
    
    //next-state logic
    always @*
        begin
            s_state_next = s_state_reg;
            s_got_code_tick = 1'b0;
            
            case(s_state_reg)
                idle:
                    if(s_scan_done_tick == 1'b1 && s_key_code != BRK) //if new key code received and is NOT BRK key (F0)
                        begin
                            s_state_next = get_code;
                            s_got_code_tick = 1'b1;  //received first key code on press down
                        end
                    
                get_code: //receive following scan code upon release of key
                    if(s_scan_done_tick)
                        begin
                            if(s_key_code == BRK)
                                s_state_next = wait_break; //don't transmit break code (F0), return to idle wait
                            else
                                s_got_code_tick = 1'b1;
                        end
                wait_break:
                    if(s_scan_done_tick) //waits for one scan so no return after break code (only before holding)
                        s_state_next = idle;
                default: s_state_next = idle;
            endcase
        end
        
endmodule