`timescale 1ns / 1ps

module logic_cluster(
    input prog_in,
    input prog_clk,
    input prog_en,
    input [10:0] in,
    input clk,
    output [4:0] out,
    output prog_out
    );
    
    wire [4:0] output_reg;
    wire [3:0] prog_conn;
    
    assign out = output_reg;
    interconnect_matrix ble_0(
        .prog_in(prog_in),
        .prog_clk(prog_clk),
        .prog_en(prog_en),
        .in({in, output_reg}),
        .clk(clk),
        .prog_out(prog_conn[0]),
        .out(output_reg[0]));    
        
    interconnect_matrix ble_1(
        .prog_in(prog_conn[0]),
        .prog_clk(prog_clk),
        .prog_en(prog_en),
        .in({in, output_reg}),
        .clk(clk),
        .prog_out(prog_conn[1]),
        .out(output_reg[1]));
        
    interconnect_matrix ble_2(
        .prog_in(prog_conn[1]),
        .prog_clk(prog_clk),
        .prog_en(prog_en),
        .in({in, output_reg}),
        .clk(clk),
        .prog_out(prog_conn[2]),
        .out(output_reg[2]));
        
    interconnect_matrix ble_3(
        .prog_in(prog_conn[2]),
        .prog_clk(prog_clk),
        .prog_en(prog_en),
        .in({in, output_reg}),
        .clk(clk),
        .prog_out(prog_conn[3]),
        .out(output_reg[3]));
        
    interconnect_matrix ble_4(
        .prog_in(prog_conn[3]),
        .prog_clk(prog_clk),
        .prog_en(prog_en),
        .in({in, output_reg}),
        .clk(clk),
        .prog_out(prog_out),
        .out(output_reg[4]));
endmodule
