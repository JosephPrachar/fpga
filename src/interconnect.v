`timescale 1ns / 1ps

module interconnect_matrix(
    input prog_in,
    input prog_clk,
    input prog_en,
    input clk,
    input [15:0] in,
    output prog_out,
    output out
    );

    wire [3:0]prog_connect;
    wire [3:0]input_reg;
    
    prog_mux16 mux0 (
        .in(in),
        .prog_in(prog_in),
        .prog_clk(prog_clk),
        .prog_en(prog_en),
        .out(input_reg[0]),
        .prog_out(prog_connect[0]));
    prog_mux16 mux1 (
        .in(in),
        .prog_in(prog_connect[0]),
        .prog_clk(prog_clk),
        .prog_en(prog_en),
        .out(input_reg[1]),
        .prog_out(prog_connect[1]));
    prog_mux16 mux2 (
        .in(in),
        .prog_in(prog_connect[1]),
        .prog_clk(prog_clk),
        .prog_en(prog_en),
        .out(input_reg[2]),
        .prog_out(prog_connect[2]));
    prog_mux16 mux3 (
        .in(in),
        .prog_in(prog_connect[2]),
        .prog_clk(prog_clk),
        .prog_en(prog_en),
        .out(input_reg[3]),
        .prog_out(prog_connect[3]));
    
    BLE ble1(
        .prog_in(prog_connect[3]),
        .prog_clk(prog_clk),
        .prog_en(prog_en),
        .clk(clk),
        .in(input_reg),
        .prog_out(prog_out),
        .out(out));
    
endmodule
