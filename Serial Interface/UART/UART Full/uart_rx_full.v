`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/24/2022 02:47:03 PM
// Design Name: 
// Module Name: uart_rx_full
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


module uart_rx_full(
    input i_clk, i_reset, 
    input i_rx,                  //receive bit
    input i_baud_tick,           //enable start tick from baud rate generator. samples 16 times per bit
    input [1:0] i_data_num,      //number of data bits: 00 is 6 bits, 01 is 7 bits, 10 is 8 bits
    input [1:0] i_stop_num,      //number of stop bits: 00 is 1 bit, 01 is 1.5 bits, 10 is 2 bits
    input [1:0] i_par,           //specifies parity scheme: 00 is no parity, 01 is even parity, 10 is odd parity
    output reg  o_par_err,       //parity error active if 1
    output reg  o_frm_err,       //frame error active if 1
    output reg  o_rx_done_tick,  //tick when whole word received
    output [7:0] o_data          //output received word
    );
    
    localparam [2:0] idle   = 3'b000, 
                     start  = 3'b001, 
                     data   = 3'b010, 
                     parity = 3'b011,
                     stop   = 3'b100;
                     
    reg [2:0]      s_state_reg,  s_state_next;  //state register
    reg [4:0]      s_s_reg,      s_s_next;      //counter for baud rate ticks (samples every 16 baud ticks, or potentially more for stop bit)
    reg [2:0]      s_n_reg,      s_n_next;      //n keeps track of sampling data bit
    reg [7:0]      s_b_reg,      s_b_next;      //reg to store received data bits, max set by DBIT parameter
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
                s_parity_reg <= 0;
            end
        else
            begin
                s_state_reg   <= s_state_next;
                s_s_reg       <= s_s_next;
                s_n_reg       <= s_n_next;
                s_b_reg       <= s_b_next;
                s_parity_reg <= s_parity_next;
            end
    
    always @*
        begin
            //default assignments
            s_state_next  = s_state_reg;
            s_s_next      = s_s_reg;
            s_n_next      = s_n_reg;
            s_b_next      = s_b_reg;
            s_parity_next = s_parity_reg;
            
            o_par_err = 1'b0;
            o_frm_err = 1'b0;
            o_rx_done_tick = 1'b0;
            
            case (s_state_reg)
                idle:
                    if(~i_rx) //wait for 0 start bit
                        begin
                            s_state_next = start;
                            s_s_next = 0;
                            s_parity_next = 1'b0;
                        end
                start:
                    if(i_baud_tick) //samples 16 times per bit
                        if(s_s_reg == 7) //checks against middle sample (7/16) of start bit
                            begin
                                s_state_next = data;
                                s_s_next = 0;
                                s_n_next = 0;
                            end
                        else
                            s_s_next = s_s_reg + 1;
                data:
                    if(i_baud_tick)
                        if (s_s_reg == 15) //samples after 15 more ticks since goes from middle of start bit to middle of data bit
                            begin
                                s_s_next = 0; //reset tick counter to 0
                                s_b_next = {i_rx, s_b_reg[7:1]}; //shift received bits right since LSB received first
                                
                                if (i_rx == 1'b1) //if 1 received, alternate parity count between even and odd number of 1's
                                    s_parity_next = ~s_parity_reg;
                                    
                                if (s_n_reg == s_dbit_num - 1) //if read last data bit
                                    begin
                                        s_state_next = (i_par == 2'b01 || i_par == 2'b10) ? parity : stop; //if parity bit checked, go to parity state
                                        if(i_data_num == 2'b00) //6 data bits, shift twice right to LSB
                                            s_b_next = s_b_next >> 2;
                                        else if(i_data_num == 2'b01) //7 data bits, shift once right to LSB
                                            s_b_next = s_b_next >> 1;
                                    end
                                else
                                    s_n_next = s_n_reg + 1;
                            end
                        else
                            s_s_next = s_s_reg + 1;
                parity:
                    if(i_baud_tick)
                        if (s_s_reg == 15) //samples after 15 more ticks since goes from middle of start bit to middle of data bit
                            begin
                                s_s_next = 0; //reset tick counter to 0
                                
                                if((i_par == 2'b01) && (i_rx == ~s_parity_reg)) //if even parity and counted vs recieved parity differ, error set
                                    o_par_err = 1'b1; //set parity error to ACTIVE (1)
                                else if((i_par == 2'b10) && (i_rx == s_parity_reg)) //if odd parity and counted vs recieved parity differ, error set
                                    o_par_err = 1'b1;
                                    
                                s_state_next = stop;
                            end
                        else
                            s_s_next = s_s_reg + 1;
                stop:
                    if(i_baud_tick)
                        if(s_s_reg == (s_stop_num - 1)) //monitors stop bit after 16, 24, or 32 ticks to read in middle
                            begin
                                if(~i_rx) //if stop bit not 1, frame error detected (not at end of transmit)
                                    o_frm_err = 1'b1;
                                
                                s_state_next = idle;
                                o_rx_done_tick = 1'b1;
                            end
                        else
                            s_s_next = s_s_reg + 1;
                default: s_state_next = idle;
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
    assign o_data = s_b_reg;
        
endmodule
