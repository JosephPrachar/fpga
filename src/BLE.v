`timescale 1ns / 1ps

module BLE(
    input prog_in,
    input prog_clk,
    input prog_en,
    input clk,
    input [3:0] in,
    output prog_out,
    output out
    );
    
    wire lut4_out;
    wire output_reg;
    wire [3:0] input_reg;
    
    reg flip_flop = 0;
    wire flip_flop_en;
    
    reg [18:0] prog_control;
    reg [18:0] control;
    // control[0:15] for 4-LUT
    // control[16] controls mux for FF-enable pin
    // control[17] controls mux for LUT-4 input 0 being feedback or in[0]
    // control[18] controls mux for out being from LUT-4 or FF
    
    // Create shift register out of control
    always @(posedge prog_clk) begin
        if (prog_en == 1)
            prog_control <= { prog_control[17:0], prog_in };
    end
    
    always @(negedge prog_en) begin
        control <= prog_control;
    end
    
    // Keep chain of shift registers going to next CLB
    assign prog_out = prog_control[18];
    
        // set mux for FF-enable
    assign flip_flop_en = (control[16] == 0) ? 1 : in[3];
        // Set mux for LUT-4 input
    assign input_reg = (control[17] == 0) ? { in[3:1], in[0]} : { in[3:1], flip_flop };
        // Set mux for output
    assign output_reg = (control[18] == 0) ? lut4_out : flip_flop;      

    assign out = output_reg;
    
    mux16 mux(
        .in(control[15:0]),
        .sel(input_reg),
        .out(lut4_out));
    
    always @(posedge clk) begin
        if (flip_flop_en == 1)
            flip_flop <= lut4_out;
    end
    
endmodule
