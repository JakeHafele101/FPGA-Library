`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/03/2023 09:26:44 PM
// Design Name: 
// Module Name: kb_monitor
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


module kb_monitor(
    input i_clk, i_reset, 
    input i_ps2d, i_ps2c, 
    output o_tx
    );
    
    parameter DBIT = 8,      //bits of data in word
              SB_TICK = 16,  //ticks for stop bit. 16 = 1 bit, 24 for 1.5 bits, 32 for 2 bits
              DVSR = 326,    //counter for baud rate of 19,200
              DVSR_BIT = 9,  //number of bits for DVSR counter for baud rate tick generator
              FIFO_W = 2;    //number of address bits in FIFO buffer
    
    localparam SP = 8'h20; //space in ASCII
    
    localparam [1:0] idle  = 2'b00,
                     send1 = 2'b01,
                     send0 = 2'b10, 
                     sendb = 2'b11;
    
    reg [1:0] s_state_reg, s_state_next;
    
    wire [7:0] s_scan_data;
    wire s_scan_done_tick;

    reg [7:0] s_wr_data;
    reg s_wr_uart;
    
    reg [7:0] s_ascii_code;
    wire [3:0] s_hex_in;
    
    //ps2 receiver
    ps2_rx ps2_rx(.i_clk(i_clk), .i_reset(i_reset), .i_ps2d(i_ps2d), .i_ps2c(i_ps2c), .i_rx_en(1'b1), .o_rx_done_tick(s_scan_done_tick), .o_data(s_scan_data));
    
    //instantiate uart module, only using tx
    //19,600 baud rate, 8 data bits, 1 stop bit, no parity
    uart #(.DBIT(DBIT), .SB_TICK(SB_TICK), .DVSR(DVSR), .DVSR_BIT(DVSR_BIT), .FIFO_W(FIFO_W)) 
         uart(.i_clk(i_clk), .i_reset(i_reset), .i_rd_uart(1'b0), .i_wr_uart(s_wr_uart), .i_rx(1'b1), .i_wr_data(s_wr_data), 
              .o_tx_full(), .o_rx_empty(), .o_tx(o_tx), .o_rd_data());
    
    //state registers
    always @(posedge i_clk, posedge i_reset)
        if(i_reset)
            s_state_reg <= idle;
        else
            s_state_reg <= s_state_next;     
    
    //next state logic
    always @*
        begin
            s_state_next = s_state_reg;
            s_wr_uart = 1'b0;
            s_wr_data = SP;
            
            case(s_state_reg)
                idle:   
                    if(s_scan_done_tick) //scan code received from ps2_rx
                        s_state_next = send1;
                send1: //sends larger hex char
                    begin
                        s_wr_data = s_ascii_code;
                        s_wr_uart = 1'b1;
                        s_state_next = send0;
                    end
                send0: //sends lower hex char
                    begin
                        s_wr_data = s_ascii_code;
                        s_wr_uart = 1'b1;
                        s_state_next = sendb;
                    end
                sendb: //send blank char (a space)
                    begin
                        s_wr_data = SP;
                        s_wr_uart = 1'b1;
                        s_state_next = idle;
                    end
            endcase
        end
    
    assign s_hex_in = (s_state_reg == send1) ? s_scan_data[7:4] : //if sending larger hex value, read four MSB
                                               s_scan_data[3:0];  //if sending smaller hex value, read four LSB
                                             
    //hex digit to ASCII code
    always @*
        case(s_hex_in)
            4'h0: s_ascii_code = 8'h30; //0
            4'h1: s_ascii_code = 8'h31; //1
            4'h2: s_ascii_code = 8'h32; //2
            4'h3: s_ascii_code = 8'h33; //3
            4'h4: s_ascii_code = 8'h34; //4
            4'h5: s_ascii_code = 8'h35; //5
            4'h6: s_ascii_code = 8'h36; //6
            4'h7: s_ascii_code = 8'h37; //7
            4'h8: s_ascii_code = 8'h38; //8
            4'h9: s_ascii_code = 8'h39; //9
            4'ha: s_ascii_code = 8'h41; //A
            4'hb: s_ascii_code = 8'h42; //B
            4'hc: s_ascii_code = 8'h43; //C
            4'hd: s_ascii_code = 8'h44; //D
            4'he: s_ascii_code = 8'h45; //E
            default: s_ascii_code = 8'h46; //F
        endcase
    
endmodule
