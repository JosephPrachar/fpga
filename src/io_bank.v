`timescale 1ns / 1ps

module io_bank #(parameter SIZE = 5) (
    input [SIZE-1:0]to_pad,
    output [SIZE-1:0]from_pad,
    inout [SIZE-1:0]io_pad,
    input prog_in,
    input prog_clk,
    input prog_en,
    output prog_out
    );
    
    wire [SIZE:0]prog_connect;
    
    assign prog_connect[0] = prog_in;
    assign prog_out = prog_connect[SIZE];

    genvar index;
    generate
    for (index=0; index < SIZE; index=index+1) begin
        io_block io_block_i (
            .to_pad(to_pad[index]),
            .from_pad(from_pad[index]),
            .io_pad(io_pad[index]),
            .prog_in(prog_connect[index]),
            .prog_clk(prog_clk),
            .prog_en(prog_en),
            .prog_out(prog_connect[index + 1]));
    end
    endgenerate

endmodule
