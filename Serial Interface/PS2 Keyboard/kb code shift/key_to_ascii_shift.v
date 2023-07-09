`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/10/2023 06:24:04 PM
// Design Name: 
// Module Name: key_to_ascii_shift
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


module key_to_ascii_shift(
    input [8:0] i_key_code, 
    output reg [7:0] o_ascii_code
    );
    
    always @*
        if(i_key_code[8]) //if shift active
            case(i_key_code[7:0])
                8'h45: o_ascii_code = 8'h29; // )
                8'h16: o_ascii_code = 8'h21; // !
                8'h1e: o_ascii_code = 8'h40; // @
                8'h26: o_ascii_code = 8'h23; // #
                8'h25: o_ascii_code = 8'h24; // $
                8'h2e: o_ascii_code = 8'h25; // %
                8'h36: o_ascii_code = 8'h5e; // ^
                8'h3d: o_ascii_code = 8'h26; // &
                8'h3e: o_ascii_code = 8'h2a; // *
                8'h46: o_ascii_code = 8'h28; // (
                
                8'h1c: o_ascii_code = 8'h41; // A
                8'h32: o_ascii_code = 8'h42; // B
                8'h21: o_ascii_code = 8'h43; // C
                8'h23: o_ascii_code = 8'h44; // D
                8'h24: o_ascii_code = 8'h45; // E
                8'h2b: o_ascii_code = 8'h46; // F
                8'h34: o_ascii_code = 8'h47; // G
                8'h33: o_ascii_code = 8'h48; // H
                8'h43: o_ascii_code = 8'h49; // I
                8'h3b: o_ascii_code = 8'h4a; // J
                8'h42: o_ascii_code = 8'h4b; // K
                8'h4b: o_ascii_code = 8'h4c; // L
                8'h3a: o_ascii_code = 8'h4d; // M
                8'h31: o_ascii_code = 8'h4e; // N
                8'h44: o_ascii_code = 8'h4f; // O
                8'h4d: o_ascii_code = 8'h50; // P
                8'h15: o_ascii_code = 8'h51; // Q
                8'h2d: o_ascii_code = 8'h52; // R
                8'h1b: o_ascii_code = 8'h53; // S
                8'h2c: o_ascii_code = 8'h54; // T
                8'h3c: o_ascii_code = 8'h55; // U
                8'h2a: o_ascii_code = 8'h56; // V
                8'h1d: o_ascii_code = 8'h57; // W
                8'h22: o_ascii_code = 8'h58; // X
                8'h35: o_ascii_code = 8'h59; // Y
                8'h1a: o_ascii_code = 8'h5a; // Z
                
                8'h0e: o_ascii_code = 8'h27; // `
                8'h4e: o_ascii_code = 8'h5f; // _
                8'h55: o_ascii_code = 8'h2b; // +
                8'h54: o_ascii_code = 8'h7b; // {
                8'h5b: o_ascii_code = 8'h7d; // }
                8'h5d: o_ascii_code = 8'h7c; // |
                8'h4c: o_ascii_code = 8'h3a; // :
                8'h52: o_ascii_code = 8'h22; // "
                8'h41: o_ascii_code = 8'h3c; // <
                8'h49: o_ascii_code = 8'h3e; // >
                8'h4a: o_ascii_code = 8'h3f; // ?
                
                8'h29: o_ascii_code = 8'h20; // (space)
                8'h5a: o_ascii_code = 8'h0d; // (enter, cr)
                8'h66: o_ascii_code = 8'h08; // (backspace)
                default: o_ascii_code = 8'h2a; // *
            endcase
        else //shift not active
            case(i_key_code[7:0])
                8'h45: o_ascii_code = 8'h30; // 0
                8'h16: o_ascii_code = 8'h31; // 1
                8'h1e: o_ascii_code = 8'h32; // 2
                8'h26: o_ascii_code = 8'h33; // 3
                8'h25: o_ascii_code = 8'h34; // 4
                8'h2e: o_ascii_code = 8'h35; // 5
                8'h36: o_ascii_code = 8'h36; // 6
                8'h3d: o_ascii_code = 8'h37; // 7
                8'h3e: o_ascii_code = 8'h38; // 8
                8'h46: o_ascii_code = 8'h39; // 9
                
                8'h1c: o_ascii_code = 8'h61; // a
                8'h32: o_ascii_code = 8'h62; // b
                8'h21: o_ascii_code = 8'h63; // c
                8'h23: o_ascii_code = 8'h64; // d
                8'h24: o_ascii_code = 8'h65; // e
                8'h2b: o_ascii_code = 8'h66; // f
                8'h34: o_ascii_code = 8'h67; // g
                8'h33: o_ascii_code = 8'h68; // h
                8'h43: o_ascii_code = 8'h69; // i
                8'h3b: o_ascii_code = 8'h6a; // j
                8'h42: o_ascii_code = 8'h6b; // k
                8'h4b: o_ascii_code = 8'h6c; // l
                8'h3a: o_ascii_code = 8'h6d; // m
                8'h31: o_ascii_code = 8'h6e; // n
                8'h44: o_ascii_code = 8'h6f; // o
                8'h4d: o_ascii_code = 8'h70; // p
                8'h15: o_ascii_code = 8'h71; // q
                8'h2d: o_ascii_code = 8'h72; // r
                8'h1b: o_ascii_code = 8'h73; // s
                8'h2c: o_ascii_code = 8'h74; // t
                8'h3c: o_ascii_code = 8'h75; // u
                8'h2a: o_ascii_code = 8'h76; // v
                8'h1d: o_ascii_code = 8'h77; // w
                8'h22: o_ascii_code = 8'h78; // x
                8'h35: o_ascii_code = 8'h79; // y
                8'h1a: o_ascii_code = 8'h7a; // z
                
                8'h0e: o_ascii_code = 8'h7e; // ~
                8'h4e: o_ascii_code = 8'h2d; // -
                8'h55: o_ascii_code = 8'h3d; // =
                8'h54: o_ascii_code = 8'h5b; // [
                8'h5b: o_ascii_code = 8'h5d; // ]
                8'h5d: o_ascii_code = 8'h5c; // \
                8'h4c: o_ascii_code = 8'h3b; // ;
                8'h52: o_ascii_code = 8'h27; // '
                8'h41: o_ascii_code = 8'h2c; // ,
                8'h49: o_ascii_code = 8'h2e; // .
                8'h4a: o_ascii_code = 8'h2f; // /
                
                8'h29: o_ascii_code = 8'h20; // (space)
                8'h5a: o_ascii_code = 8'h0d; // (enter, cr)
                8'h66: o_ascii_code = 8'h08; // (backspace)
                default: o_ascii_code = 8'h2a; // *
            endcase
endmodule
