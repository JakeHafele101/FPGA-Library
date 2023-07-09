`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/21/2022 12:31:31 PM
// Design Name: 
// Module Name: FIFO
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


module FIFO(
    input i_clk, i_reset,
    input i_wr, i_rd,
    input [B-1:0] i_wr_data,
    output o_empty, o_full,
    output [B-1:0] o_rd_data
    );
    
    parameter B = 8,  //number of data bits in each word (8 by default)
              W = 4;  //number of address bits (15 words total by default)
    
    reg [B-1:0] s_array_reg [2**W-1:0];
    reg [W-1:0] s_wr_ptr_reg, s_wr_ptr_next;
    reg [W-1:0] s_rd_ptr_reg, s_rd_ptr_next;
    reg         s_full_reg, s_full_next, s_empty_reg, s_empty_next;
    
    wire [W-1:0] s_wr_ptr_succ, s_rd_ptr_succ;
    wire         s_wr_en;
    
    //register write operation
    always @(posedge i_clk)
        if(s_wr_en)
            s_array_reg[s_wr_ptr_reg] <= i_wr_data;
    
    always @(posedge i_clk, posedge i_reset)
        if (i_reset)
            begin
                s_wr_ptr_reg <= 0;
                s_rd_ptr_reg <= 0;
                s_full_reg  <= 1'b0;
                s_empty_reg <= 1'b1;
            end
        else
            begin
                s_wr_ptr_reg <= s_wr_ptr_next;
                s_rd_ptr_reg <= s_rd_ptr_next;
                s_full_reg   <= s_full_next;
                s_empty_reg  <= s_empty_next;
            end
    
    always @*
        begin
            //default: keep old values
            s_wr_ptr_next = s_wr_ptr_reg;
            s_rd_ptr_next = s_rd_ptr_reg;
            s_full_next   = s_full_reg;
            s_empty_next  = s_empty_reg;
            
            case({i_wr, i_rd})
                //2'b00 no op
                2'b01: //read
                    if(~s_empty_reg)
                        begin
                            s_rd_ptr_next = s_rd_ptr_succ;
                            s_full_next = 1'b0;
                            if(s_rd_ptr_succ == s_wr_ptr_reg)
                                s_empty_next = 1'b1;
                        end
                2'b10: //write
                    if(~s_full_reg)
                        begin
                            s_wr_ptr_next = s_wr_ptr_succ;
                            s_empty_next = 1'b0;
                            if(s_wr_ptr_succ == s_rd_ptr_reg)
                                s_full_next = 1'b1;
                        end
                2'b11: //read and write
                    begin
                        s_rd_ptr_next = s_rd_ptr_succ;
                        s_wr_ptr_next = s_wr_ptr_succ;
                    end
            endcase
        end
        
    //data functions
    assign s_wr_ptr_succ = s_wr_ptr_reg + 1;
    assign s_rd_ptr_succ = s_rd_ptr_reg + 1;
    assign s_wr_en = i_wr && ~s_full_reg;
    
    //output assignments
    assign o_empty = s_empty_reg;
    assign o_full  = s_full_reg;
    assign o_rd_data = s_array_reg[s_rd_ptr_reg];
    
endmodule
