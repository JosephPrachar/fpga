`timescale 1ns / 1ps

module prog_mux #(parameter SEL = 4, parameter INPUTS = 16) (
    input [INPUTS-1:0] in,
    input prog_in,
    input prog_clk,
    input prog_en,
    output out,
    output prog_out
    );

    reg [SEL-1:0] control;
    
    // Create shift register out of "control"
    always @(posedge prog_clk) begin
        if (prog_en == 1)
            control <= { control[SEL-2:0], prog_in };
    end
    // Keep chain of shift registers going to next CLB
    assign prog_out = control[SEL-1];
    
    mux #(SEL, INPUTS) mux_i(
        .in(in),
        .sel(control),
        .out(out));
endmodule
