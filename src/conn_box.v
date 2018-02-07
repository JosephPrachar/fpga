`timescale 1ns / 1ps

module conn #(parameter INPUTS = 16, parameter OUTPUTS = 20)(
    input prog_in,
    input prog_clk,
    input prog_en,
    input [INPUTS-1:0] in,
    output prog_out,
    output [OUTPUTS-1:0]out
    );

    wire [OUTPUTS-2:0]prog_connect;
    
    prog_mux16 mux_start (
        .in(in),
        .prog_in(prog_in),
        .prog_clk(prog_clk),
        .prog_en(prog_en),
        .out(out[0]),
        .prog_out(prog_connect[0]));
    
    genvar index;
    generate
    for (index=1; index < OUTPUTS - 1; index=index+1) begin
        prog_mux16 mux_i (
            .in(in),
            .prog_in(prog_connect[index - 1]),
            .prog_clk(prog_clk),
            .prog_en(prog_en),
            .out(out[index]),
            .prog_out(prog_connect[index]));
    end
    endgenerate
    
    prog_mux16 mux_end (
        .in(in),
        .prog_in(prog_connect[OUTPUTS - 2]),
        .prog_clk(prog_clk),
        .prog_en(prog_en),
        .out(out[OUTPUTS - 1]),
        .prog_out(prog_out));
    
endmodule
