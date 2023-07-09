`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/03/2023 08:59:06 PM
// Design Name: 
// Module Name: ps2_rx
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


module ps2_rx(
    input i_clk, i_reset,
    input i_ps2d,                //ps2 data line, inncluding 1 start bit (0), 8 data bits, odd parity bit, and stop bit (1). idle bit 1
    input i_ps2c,                //ps2 clock line, read bits of ps2d on negative edge 
    input i_rx_en,               //receives if rx_en is 1 and detects start bit
    output reg o_rx_done_tick,   //done tick after stop bit received
    output wire [7:0] o_data     //8 data bit output from read
    );
    
    //state declaration
    localparam [1:0] idle = 2'b00,
                     rx   = 2'b01,
                     load = 2'b10;
    
    reg  [1:0] s_state_reg, s_state_next; //register to hold current and next state data
    
    reg  [7:0] s_filter_reg;  //register holds last 8 sampled clock signals from i_ps2c
    wire [7:0] s_filter_next;
    reg  s_f_ps2c_reg;        //register holds filtered clock signal that updates after same bit read for 8 samples from i_ps2c (s_filter_reg has same 8 bits)
    wire s_f_ps2c_next;
    wire s_fall_edge;        //falling edge 1 when current f_ps2c is 1 and next f_ps2c is 0. used to tell when to scan i_ps2d in FSMD 

    reg [3:0] s_n_reg, s_n_next;  //counter for n'th bit read
    reg [10:0] s_b_reg, s_b_next; //reg to collect data bits, shifts in as recieved similar to uart ((1 start bit, 8 data bits, 1 parity bit, 1 stop bit)
        
    //filter and falling edge tick generation for ps2c
    always @(posedge i_clk, posedge i_reset)
        if(i_reset)
            begin
                s_filter_reg <= 0;
                s_f_ps2c_reg <= 0;
            end
        else
            begin
                s_filter_reg <= s_filter_next;
                s_f_ps2c_reg <= s_f_ps2c_next;
            end
            
    assign s_filter_next = {i_ps2c, s_filter_reg[7:1]}; //appends sampled ps2c clock signal to MSB, shifts out LSB of s_filter_reg to compare new clock signal to previous 7 sampled
    
    assign s_f_ps2c_next = (s_filter_reg == 8'b11111111) ? 1'b1 : //update filtered clock signal to 1 if last 8 samples were 1
                           (s_filter_reg == 8'b00000000) ? 1'b0 : //update filtered clock signal to 0 if last 8 samples were 0
                            s_f_ps2c_reg;                         //otherwise, keep previous filtered clock signal until same 8 samples
                            
    assign s_fall_edge = s_f_ps2c_reg && ~s_f_ps2c_next; //falling edge tick if previous f_ps2c was 1 and next f_ps2c is 0 (1 to 0, falling)
    
    // FSMD for data rx
    //state and data registers
    always @(posedge i_clk, posedge i_reset)
        if(i_reset)
            begin
                s_state_reg <= 0;
                s_n_reg     <= 0;
                s_b_reg     <= 0;
            end
        else
            begin
                s_state_reg <= s_state_next;
                s_n_reg     <= s_n_next;
                s_b_reg     <= s_b_next;
            end
    
    //next-state logic
    always @*
        begin
            s_state_next = s_state_reg;
            s_n_next = s_n_reg;
            s_b_next = s_b_reg;
            
            o_rx_done_tick = 1'b0;
            
            case(s_state_reg)
                idle:
                    if(s_fall_edge && i_rx_en && i_ps2d == 1'b0) //start collecting if ps2c falling edge, i_rx_en active, and start bit is 0
                        begin
                            s_state_next = rx;
                            s_n_next = 4'b1001; //9 more bits to collect (8 data bits, 1 parity bit)
                            s_b_next = {i_ps2d, s_b_reg[10:1]}; //shift in start bit as MSB
                        end
                rx:
                    if(s_fall_edge) //if falling edge of clock
                        begin
                            s_b_next = {i_ps2d, s_b_reg[10:1]}; //shift in data bits, then finally parity bit when n = 0
                            if(s_n_reg == 0)
                                s_state_next = load;
                            else
                                s_n_next = s_n_reg - 1;
                        end
                load: //1 extra clock cycle needed to load s_b_next
                    begin
                        s_state_next = idle;
                        o_rx_done_tick = 1'b1;
                    end
                default: s_state_next = idle;
            endcase
        end
    
    //output logic
    assign o_data = s_b_reg[8:1]; //data bits output
    
endmodule
