`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/01/2023 10:00:35 PM
// Design Name: 
// Module Name: enhanced_stopwatch_receive_interface
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

//module to handle incoming ascii commands from uart recieve buffer
module enhanced_stopwatch_receive_interface(
    input i_clk, i_reset, 
    input [7:0] i_ascii, 
    input  i_rd_ascii, 
    output o_go, 
    output o_clr,
    output o_up,
    output reg o_tx_start_tick
    );
    
    reg s_go_reg,  s_go_next;
    reg s_clr_reg, s_clr_next;
    reg s_up_reg,  s_up_next;
    
    always @(posedge i_clk, posedge i_reset)
        if(i_reset)
            begin
                s_go_reg  <= 1'b0;
                s_clr_reg <= 1'b1;
                s_up_reg  <= 1'b1;
            end
        else
            begin
                s_go_reg  <= s_go_next;
                s_clr_reg <= s_clr_next;
                s_up_reg  <= s_up_next;
            end
    
    always @*
        begin
            //default updates
            s_go_next = s_go_reg;
            s_clr_next = s_clr_reg;
            s_up_next = s_up_reg;
            
            o_tx_start_tick = 1'b0;
            
            if(i_rd_ascii) //if ascii should be read (FIFO receive buffer not empty)
                if(i_ascii == 8'h43 || i_ascii == 8'h63) //C or c for clear
                    begin
                        s_go_next  = 1'b0; //aborts current counting
                        s_clr_next = 1'b1; //clears counter
                        s_up_next  = 1'b1; //sets counter to up direction
                    end
                else if(i_ascii == 8'h47 || i_ascii == 8'h67) //G or g for go
                    begin
                        s_go_next = 1'b1; //starts counting
                        s_clr_next = 1'b0; //stops clear
                    end
                else if(i_ascii == 8'h50 || i_ascii == 8'h70) //P or p for pause
                    s_go_next = 1'b0; //stops counting
                else if(i_ascii == 8'h55 || i_ascii == 8'h75) //U or u for up-down (reverses direction)
                    s_up_next <= ~s_up_reg;
                else if(i_ascii == 8'h52 || i_ascii == 8'h72) //R or r for receive time
                    o_tx_start_tick = 1'b1; //sets tick for one cycle 
        end
    
    //data output
    assign o_go = s_go_reg;
    assign o_clr = s_clr_reg;
    assign o_up = s_up_reg;
    
endmodule
