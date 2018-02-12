`timescale 1ns / 1ps

module fpgav1(
    input prog_in,
    input prog_clk,
    input prog_en,
    input clk,
    inout [15:0] io,
    output prog_out
    );
    
    wire [10:0] lc_inputs;
    wire [4:0] lc_outputs;
    wire prog_connection;
    
    io_bank #(16) io_bank_i(
        .prog_in(prog_in),
        .prog_clk(prog_clk),
        .prog_en(prog_en),
        .io_pad(io),
        .fpga({lc_outputs, lc_inputs}),
        .prog_out(prog_connection)
    );
    
    logic_cluster lc_i(
        .prog_in(prog_connection),
        .prog_clk(prog_clk),
        .prog_en(prog_en),
        .in(lc_inputs),
        .clk(clk),
        .out(lc_outputs),
        .prog_out(prog_out)
        );

endmodule
