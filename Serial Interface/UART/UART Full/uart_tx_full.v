`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/24/2022 02:47:03 PM
// Design Name: 
// Module Name: uart_tx_full
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


module uart_tx_full(
    input i_clk, i_reset, 
    input i_tx_start,           //receive bit
    input i_baud_tick,          //enable start tick from baud rate generator. samples 16 times per bit
    input [1:0] i_data_num,      //number of data bits: 00 is 6 bits, 01 is 7 bits, 10 is 8 bits
    input [1:0] i_stop_num,      //number of stop bits: 00 is 1 bit, 01 is 1.5 bits, 10 is 2 bits
    input [1:0] i_par,           //specifies parity scheme: 00 is no parity, 01 is even parity, 10 is odd parity
    input [7:0] i_data,
    output reg o_tx_done_tick, 
    output o_tx
    );
              
    localparam [2:0] idle   = 3'b000, 
                     start  = 3'b001, 
                     data   = 3'b010, 
                     parity = 3'b011,
                     stop   = 3'b100;
                     
    reg [2:0]      s_state_reg, s_state_next;  //state register
    reg [4:0]      s_s_reg,     s_s_next;      //reg for 16 tick samples per bit
    reg [2:0]      s_n_reg,     s_n_next;      //n keeps track of sampling data bit
    reg [7:0]      s_b_reg,     s_b_next;      //reg to store received data bits, max set by DBIT parameter
    reg            s_tx_reg,    s_tx_next;     //1 bit output buffer to avoid glitches
    reg            s_parity_reg, s_parity_next; //if 0, even number of ones. if 1, odd number of one bits received

    
    wire [3:0] s_dbit_num; //either 6, 7, or 8 data bits
    wire [5:0] s_stop_num; //either 16. 24. or 32 for 1, 1.5, or 2 stop bits
        
    always @(posedge i_clk, posedge i_reset)
        if(i_reset)
            begin
                s_state_reg  <= idle;
                s_s_reg      <= 0;
                s_n_reg      <= 0;
                s_b_reg      <= 0;
                s_tx_reg     <= 1'b1;
                s_parity_reg <= 1'b0;
            end
        else
            begin
                s_state_reg  <= s_state_next;
                s_s_reg      <= s_s_next;
                s_n_reg      <= s_n_next;
                s_b_reg      <= s_b_next;
                s_tx_reg     <= s_tx_next;
                s_parity_reg <= s_parity_next;
            end
    
    always @*
        begin
            //default assignments
            s_state_next  = s_state_reg;
            s_s_next      = s_s_reg;
            s_n_next      = s_n_reg;
            s_b_next      = s_b_reg;
            s_tx_next     = s_tx_reg;
            s_parity_next = s_parity_reg;
            
            o_tx_done_tick = 1'b0;
        
            case(s_state_reg)
                idle:
                    begin
                        s_tx_next = 1'b1;
                        if(i_tx_start)
                            begin
                                s_state_next = start;
                                s_s_next = 0;
                                s_b_next = i_data;
                                s_parity_next = 1'b0;
                            end
                    end
                start:
                    begin
                        s_tx_next = 1'b0;
                        if(i_baud_tick)
                            if(s_s_reg == 15)
                                begin
                                    s_state_next = data;
                                    s_s_next = 0;
                                    s_n_next = 0;
                                end
                            else 
                                s_s_next = s_s_reg + 1;
                    end
                data:
                    begin
                    s_tx_next = s_b_reg[0];
                        if(i_baud_tick)
                            if (s_s_reg == 15) //samples after 15 more ticks since goes from middle of start bit to middle of data bit
                                begin
                                    s_s_next = 0; //reset tick counter to 0
                                    s_b_next = s_b_reg >> 1; //shift transmit bits right 1 since LSB received first
                                    
                                    if (s_tx_next == 1'b1) //if 1 transmitted, alternate parity count between even and odd number of 1's
                                        s_parity_next = ~s_parity_reg;
                                    
                                    if (s_n_reg == s_dbit_num - 1) //if read last data bit
                                        s_state_next = (i_par == 2'b01 || i_par == 2'b10) ? parity : stop; //if parity bit checked, go to parity state
                                    else
                                        s_n_next = s_n_reg + 1;
                                end
                            else
                                s_s_next = s_s_reg + 1;
                     end
                parity:
                    begin
                        s_tx_next = (i_par == 2'b01) && (s_parity_reg == 1'b1) ? 1'b1 : //if even parity, transmits 1 if odd amount of 1 data bits (s_parity_reg is 1)
                                    (i_par == 2'b10) && (s_parity_reg == 1'b0) ? 1'b1 : //if odd parity, transmits 1 if even amount of 1 data bits (s_parity_reg is 0)
                                                                                 1'b0;
                        if(i_baud_tick)
                            if (s_s_reg == 15) //samples after 15 more ticks since goes from middle of start bit to middle of data bit
                                begin
                                    s_s_next = 0; //reset tick counter to 0
                                    s_state_next = stop;
                                end
                            else
                                s_s_next = s_s_reg + 1;
                    end
                stop:
                    begin
                        s_tx_next = 1'b1;
                        if(i_baud_tick)
                            if(s_s_reg == (s_stop_num - 1)) //monitors stop bit after 16 ticks by default
                                begin
                                    s_state_next = idle;
                                    o_tx_done_tick = 1'b1;
                                end
                            else
                                s_s_next = s_s_reg + 1;
                    end
            
            endcase
        end
     
     //data functions
    assign s_dbit_num = (i_data_num == 2'b00) ? 6 : //6 data bits if 00
                        (i_data_num == 2'b01) ? 7 : //7 data bits if 01
                                                8;  //else, 8 data bits if 10 (or 11)
                                         
    assign s_stop_num = (i_stop_num == 2'b00) ? 16 : //1 stop bit
                        (i_stop_num == 2'b01) ? 24 : //1.5 stop bit
                                                32;  //2 stop bit
     
     //output data
     assign o_tx = s_tx_reg;
                    
endmodule
