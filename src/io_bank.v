`timescale 1ns / 1ps

module io_bank #(parameter SIZE = 5) (
    inout [SIZE-1:0]fpga,
    inout [SIZE-1:0]io_pad,
    input prog_in,
    input prog_clk,
    input prog_en,
    output prog_out
    );
    
    wire [SIZE-2:0]prog_connect;
    
    io_block first(
        .fpga(fpga[0]),
        .io_pad(io_pad[0]),
        .prog_in(prog_in),
        .prog_clk(prog_clk),
        .prog_en(prog_en),
        .prog_out(prog_connect[0])
    );
    
    genvar index;
    generate
    for (index=1; index < SIZE - 1; index=index+1) begin
        io_block io_block_i (
            .fpga(fpga[index]),
            .io_pad(io_pad[index]),
            .prog_in(prog_connect[index - 1]),
            .prog_clk(prog_clk),
            .prog_en(prog_en),
            .prog_out(prog_connect[index]));
    end
    endgenerate
    
    io_block last(
        .fpga(fpga[SIZE - 1]),
        .io_pad(io_pad[SIZE - 1]),
        .prog_in(prog_connect[SIZE - 2]),
        .prog_clk(prog_clk),
        .prog_en(prog_en),
        .prog_out(prog_out)
    );

endmodule
