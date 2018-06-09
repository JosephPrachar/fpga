`timescale 1ns / 1ps

module conn #(parameter INPUTS = 16, parameter OUTPUTS = 20)(
    input prog_in,
    input prog_clk,
    input prog_en,
    input [INPUTS-1:0] in,
    output prog_out,
    output [OUTPUTS-1:0]out
    );

    wire [OUTPUTS - 1:0]prog_connect;
    assign prog_connect[0] = prog_in;
    assign prog_out = prog_connect[OUTPUTS - 1];
    
    genvar index;
    generate
    for (index=0; index < OUTPUTS ; index=index+1) begin
        prog_mux16 mux_i (
            .in(in),
            .prog_in(prog_connect[index - 1]),
            .prog_clk(prog_clk),
            .prog_en(prog_en),
            .out(out[index]),
            .prog_out(prog_connect[index]));
    end
    endgenerate
    
endmodule
