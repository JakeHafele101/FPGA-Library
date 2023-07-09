`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/11/2022 06:27:28 PM
// Design Name: 
// Module Name: stack
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


module stack(
    input clk, reset,
    input push, pop,
    input [B-1:0] push_data,
    output empty, full,
    output [B-1:0] pop_data
    );
    
    parameter B = 4; //number of bits in a word (default size is a hex value, makes easy for seven seg decoder testing)
    parameter W = 4; //number of address bits for register file (addresses range 0 to 15 by default)
    
    reg [B-1:0] array_reg [2**W-1:0]; //register array
    reg [W-1:0] push_ptr_reg, push_ptr_next;
    reg [W-1:0] pop_ptr_reg, pop_ptr_next;
    reg full_reg, full_next;     //if 1, stack is full.
    reg empty_reg, empty_next;   //if 1, stack is empty
    
    wire push_en;
    
    //register file push operation
    always @(posedge clk)
        if(push_en)
            array_reg[push_ptr_reg] <= push_data;
            
    //register file pop operation
    assign pop_data = array_reg[pop_ptr_reg];
    
    //push enabled only when stack is not full
    assign push_en = push & ~full_reg;
    
    //register for push and pop pointers
    always @(posedge clk, posedge reset)
        if(reset)
            begin
                push_ptr_reg <= 0;
                pop_ptr_reg <= 0;
                full_reg <= 1'b0;   //starts empty
                empty_reg <= 1'b1;  //starts empty
            end
        else
            begin
                push_ptr_reg <= push_ptr_next;
                pop_ptr_reg <= pop_ptr_next;
                full_reg <= full_next;
                empty_reg <= empty_next;
            end
            
    //next-state logic for push and pop pointers
    always @*
        begin

            //defualt: keep old values
            push_ptr_next = push_ptr_reg;
            pop_ptr_next = pop_ptr_reg;
            full_next = full_reg;
            empty_next = empty_reg;
            
            case({push, pop})
                2'b01: //pop
                    if(~empty_reg) //not empty
                        begin
                            full_next = 1'b0;
                                
                                if(pop_ptr_reg == 0) //if pop pointer at 0, then stays at 0 address after pop
                                begin
                                    push_ptr_next = push_ptr_reg - 1;
                                    pop_ptr_next = pop_ptr_reg;
                                    empty_next = 1'b1;
                                end
                            else if (pop_ptr_reg == 2**W-1) //if full
                                begin
                                    push_ptr_next = push_ptr_reg;
                                    pop_ptr_next = pop_ptr_reg - 1;
                                end
                            else //if in middle
                                begin
                                    push_ptr_next = push_ptr_reg - 1;
                                    pop_ptr_next = pop_ptr_reg - 1;
                                end
                        end
                2'b10: //push
                    if(~full_reg) //not full
                        begin
                            empty_next = 1'b0;

                            if(push_ptr_reg == 0) //if write pointer at 0, then empty before
                                begin
                                    push_ptr_next = push_ptr_reg + 1;
                                    pop_ptr_next = pop_ptr_reg;
                                end
                            else if (push_ptr_reg == 2**W-1) //if pushing to max address, mark as full
                                begin
                                    push_ptr_next = push_ptr_reg;
                                    pop_ptr_next = pop_ptr_reg + 1;
                                    full_next = 1'b1;
                                end
                            else //if in middle
                                begin
                                    push_ptr_next = push_ptr_reg + 1;
                                    pop_ptr_next = pop_ptr_reg + 1;
                                end
                                
                        end
                2'b11: //push and pop, stays same
                    begin
                        push_ptr_next = push_ptr_reg;
                        pop_ptr_next = pop_ptr_reg;
                    end
            endcase
            
        end
    
    //output
    assign full = full_reg;
    assign empty = empty_reg;
    
endmodule
