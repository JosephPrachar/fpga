`timescale 1ns / 1ps

module logic_element(
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
    
    wire [18:0] control;
    
    shift_reg #(19) control_bits (
        .prog_in(prog_in),
        .prog_en(prog_en),
        .prog_clk(prog_clk),
        .prog_out(prog_out),
        .control(control));
    
        // set mux for FF-enable
    assign flip_flop_en = (control[16] == 0) ? 1 : in[3];
        // Set mux for LUT-4 input
    assign input_reg = (control[17] == 0) ? { in[3:1], in[0]} : { in[3:1], flip_flop };
        // Set mux for output
    assign output_reg = (control[18] == 0) ? lut4_out : flip_flop;      

    assign out = output_reg;
    
    mux #(4) mux_i(
        .in(control[15:0]),
        .sel(input_reg),
        .out(lut4_out));
    
    always @(posedge clk) begin
        if (flip_flop_en == 1)
            flip_flop <= lut4_out;
    end
    
endmodule
