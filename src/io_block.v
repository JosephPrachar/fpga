`timescale 1ns / 1ps

module io_block(
    input to_pad,
    output from_pad,
    inout io_pad,
    input prog_in,
    input prog_clk,
    input prog_en,
    output prog_out
    );
    `define DIR 0
    `define OUTPUT 0
    `define INPUT 1
    `define PULL_DOWN 1
    `define PULL_UP 2
    
    wire [2:0] control;
    
    shift_reg #(3) control_bits (
        .prog_in(prog_in),
        .prog_en(prog_en),
        .prog_clk(prog_clk),
        .prog_out(prog_out),
        .control(control));
    
    assign from_pad = (control[`DIR] == `INPUT) ? io_pad : 'dz;
    assign io_pad   = (control[`DIR] == `INPUT) ? 'dz    : to_pad;
endmodule
