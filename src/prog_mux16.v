`timescale 1ns / 1ps

module prog_mux #(parameter SEL = 4, parameter INPUTS = 16) (
    input [INPUTS-1:0] in,
    input prog_in,
    input prog_clk,
    input prog_en,
    output out,
    output prog_out
    );

    wire [SEL-1:0] control;
    
    shift_reg #(SEL) control_bits (
        .prog_in(prog_in),
        .prog_en(prog_en),
        .prog_clk(prog_clk),
        .prog_out(prog_out),
        .control(control));
    
    mux #(SEL, INPUTS) mux_i(
        .in(in),
        .sel(control),
        .out(out));
endmodule
