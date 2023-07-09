`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/01/2023 10:00:35 PM
// Design Name: 
// Module Name: enhanced_stopwatch_transmit_interface
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

//module to handle transmitting stopwatch data through receieve uart module
module enhanced_stopwatch_transmit_interface(
    input i_clk, i_reset,
    input i_start, //incoming transmit tick from command read
    input [3:0] i_d3, i_d2, i_d1, i_d0, 
    output reg [7:0] o_ascii, //ascii text of number to be sent
    output reg o_fifo_wr //outgoing transmit tick to uart transmit module
    );
    
    localparam [2:0] idle     = 3'b000,
                     newline  = 3'b001,
                     d3       = 3'b010,
                     period_1 = 3'b011,
                     d2       = 3'b100,
                     d1       = 3'b101,
                     period_2 = 3'b110,
                     d0       = 3'b111;
    
    reg [2:0] s_state_reg, s_state_next;
    reg [3:0] s_ascii_reg, s_ascii_next;
    reg [3:0] s_d3_reg, s_d2_reg, s_d1_reg, s_d0_reg;
    reg [3:0] s_d3_next, s_d2_next, s_d1_next, s_d0_next;
    
    always @(posedge i_clk, posedge i_reset)
        if (i_reset)
            begin
                s_state_reg <= idle;
                s_ascii_reg <= 0;
                s_d3_reg    <= 0;
                s_d2_reg    <= 0;
                s_d1_reg    <= 0;
                s_d0_reg    <= 0;
            end
        else
            begin
                s_state_reg <= s_state_next;
                s_ascii_reg <= s_ascii_next;
                s_d3_reg    <= s_d3_next;
                s_d2_reg    <= s_d2_next;
                s_d1_reg    <= s_d1_next;
                s_d0_reg    <= s_d0_next;
            end
            
    always @*
        begin
            //default values
            s_state_next = s_state_reg;
            s_ascii_next = s_ascii_reg;
            s_d3_next    = s_d3_reg;
            s_d2_next    = s_d2_reg;
            s_d1_next    = s_d1_reg;
            s_d0_next    = s_d0_reg;
            
            o_fifo_wr = 1'b1;
            
            case(s_state_reg)
                idle:
                    begin
                        o_fifo_wr = 1'b0;
                        if(i_start)
                            begin
                                s_state_next = newline;
                                s_ascii_next = 4'hE;
                                s_d3_next = i_d3;
                                s_d2_next = i_d2;
                                s_d1_next = i_d1;
                                s_d0_next = i_d0;
                            end
                    end
                newline: 
                    begin
                        s_ascii_next = s_d3_reg;
                        s_state_next = d3;
                    end
                d3:
                    begin
                        s_ascii_next = 4'hF;
                        s_state_next = period_1;
                    end
                period_1: 
                    begin
                        s_ascii_next = s_d2_reg; //"."
                        s_state_next = d2;
                    end
                d2:
                    begin
                        s_ascii_next = s_d1_reg;
                        s_state_next = d1;
                    end
                d1:
                    begin
                        s_ascii_next = 4'hF;
                        s_state_next = period_2;
                    end
                period_2:
                    begin
                        s_ascii_next = s_d0_reg; //"."
                        s_state_next = d0;
                    end
                d0:
                    s_state_next = idle;
                default: s_state_next = idle;
            endcase
        end     
    
    //output data
    always @*
        case(s_ascii_reg)
            4'h0: o_ascii = 8'h30; //"0"
            4'h1: o_ascii = 8'h31; //"1"
            4'h2: o_ascii = 8'h32; //"2"
            4'h3: o_ascii = 8'h33; //"3"
            4'h4: o_ascii = 8'h34; //"4"
            4'h5: o_ascii = 8'h35; //"5"
            4'h6: o_ascii = 8'h36; //"6"
            4'h7: o_ascii = 8'h37; //"7"
            4'h8: o_ascii = 8'h38; //"8"
            4'h9: o_ascii = 8'h39; //"9"
            4'hE: o_ascii = 8'h0A; //newline
            4'hF: o_ascii = 8'h2e; //".", assigned as F above for period states
            default: o_ascii = 8'h30; //"0" default
        endcase
    
    
endmodule
