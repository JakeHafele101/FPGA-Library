`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 01/10/2023 06:09:21 PM
// Design Name:
// Module Name: kb_code_shift
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


module kb_code_shift(input i_clk,
                     input i_reset,
                     input i_ps2d,
                     input i_ps2c,
                     input i_rd_key_code,
                     output [8:0] o_key_code, //if shift active, MSB is 1. if shift not active, MSB is 0
                     output o_time_out,
                     output o_kb_buf_empty);
    
    parameter FIFO_W = 2, //2^W word size for FIFO buffer
    TIMEOUT_DVSR = 10000;
    
    //state definition
    localparam wait_brk = 1'b0,
    get_code = 1'b1;
    
    //definition for special key codes break and shift
    localparam [7:0] BRK = 8'hf0, //BRK code after key released
    SHIFT = 8'h12; //code for shift key
    
    //signal declaraction
    reg s_state_reg, s_state_next;
    reg s_shift_reg, s_shift_next;
    
    wire [7:0] s_scan_out;
    wire s_scan_done_tick;
    
    reg s_got_code_tick;
    
    //ps2 receiver
    ps2_rx_watchdog #(.TIMEOUT_DVSR(TIMEOUT_DVSR))ps2_rx(.i_clk(i_clk), .i_reset(i_reset), .i_ps2d(i_ps2d), .i_ps2c(i_ps2c), .i_rx_en(1'b1), .o_rx_done_tick(s_scan_done_tick), .o_time_out(o_time_out), .o_data(s_scan_out));
    
    //FIFO buffer
    FIFO #(.B(9), .W(FIFO_W)) fifo_rx(.i_clk(i_clk), .i_reset(i_reset), .i_wr(s_got_code_tick), .i_rd(i_rd_key_code), .i_wr_data({s_shift_reg, s_scan_out}),
    .o_empty(o_kb_buf_empty), .o_full(), .o_rd_data(o_key_code));
    
    //state register
    always @(posedge i_clk, posedge i_reset)
        if (i_reset)
        begin
            s_state_reg <= wait_brk;
            s_shift_reg <= 1'b0;
        end
        else
        begin
            s_state_reg <= s_state_next;
            s_shift_reg <= s_shift_next;
            end;
            
            //next-state logic
            always @*
            begin
            s_state_next = s_state_reg;
            s_shift_next = s_shift_reg;
            
            s_got_code_tick = 1'b0;
            
            case(s_state_reg)
                wait_brk:
                if (s_scan_done_tick == 1'b1)
                    if (s_scan_out == BRK) //if new key code received and is BRK key (F0)
                        s_state_next = get_code;
                    else if (s_scan_out == SHIFT)
                        s_shift_next = 1'b1; //if shift key pressed down before BRK key, set shift reg to ACTIVE (1)
                
                get_code: //receive following scan code upon release of key
                if (s_scan_done_tick)
                begin
                    if (s_scan_out == SHIFT) //if SHIFT key code after BRK code, then shif t key released, so set shif t to inactive
                    begin
                        s_shift_next    = 1'b0;
                        s_got_code_tick = 1'b0; //no done tick since I don't want to transmit an ASCII char after shift!
                    end
                    else
                        s_got_code_tick = 1'b1; //otherwise transmit any other key code that is not shift
                    
                    s_state_next = wait_brk;
                    
                end
            endcase
        end
    
endmodule
