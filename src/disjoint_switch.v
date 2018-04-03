`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/23/2018 08:02:58 PM
// Design Name: 
// Module Name: disjoint_switch
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


module disjoint_switch #(parameter WIDTH = 1)(
    input prog_in,
    input prog_clk,
    input prog_en,
    inout [WIDTH - 1:0] l,
    inout [WIDTH - 1:0] r,
    inout [WIDTH - 1:0] t,
    inout [WIDTH - 1:0] b,
    output prog_out
    );
    localparam NUM_MUX = WIDTH * 4;
    
    wire [NUM_MUX:0]prog_connect;
    assign prog_connect[0] = prog_in;
    assign prog_out = prog_connect[NUM_MUX];
    
    genvar index;
    generate
    for (index=0; index < WIDTH; index=index+1) begin
        wire [3:0] left   = { b[index], r[index], t[index], 1'dz };
        wire [3:0] top    = { l[index], b[index], r[index], 1'dz };
        wire [3:0] right  = { t[index], l[index], b[index], 1'dz };
        wire [3:0] bottom = { r[index], t[index], l[index], 1'dz };
        prog_mux #(2, 4) mux_left (
            .in(left),
            .prog_in(prog_connect[index]),
            .prog_clk(prog_clk),
            .prog_en(prog_en),
            .out(l[index]),
            .prog_out(prog_connect[index + 1]));
        prog_mux #(2, 4) mux_top (
            .in(top),
            .prog_in(prog_connect[index + WIDTH * 1]),
            .prog_clk(prog_clk),
            .prog_en(prog_en),
            .out(t[index]),
            .prog_out(prog_connect[index + WIDTH * 1 + 1]));
        prog_mux #(2, 4) mux_right (
            .in(right),
            .prog_in(prog_connect[index + WIDTH * 2]),
            .prog_clk(prog_clk),
            .prog_en(prog_en),
            .out(r[index]),
            .prog_out(prog_connect[index + WIDTH * 2 + 1]));
        prog_mux #(2, 4) mux_bottom (
            .in(bottom),
            .prog_in(prog_connect[index + WIDTH * 3]),
            .prog_clk(prog_clk),
            .prog_en(prog_en),
            .out(b[index]),
            .prog_out(prog_connect[index + WIDTH * 3 + 1]));
    end
    endgenerate
    
endmodule
