`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/23/2018 08:02:58 PM
// Design Name: 
// Module Name: disjoint_switch
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module disjoint_switch #(parameter WIDTH = 3)(
    input prog_in,
    input prog_clk,
    input prog_en,
    inout [WIDTH - 1:0] l,
    inout [WIDTH - 1:0] r,
    inout [WIDTH - 1:0] t,
    inout [WIDTH - 1:0] b,
    output prog_out
    );
    parameter NUM_BITS = WIDTH * 4 * 2;
    
    
    reg [NUM_BITS - 1:0] prog_control;
    reg [NUM_BITS - 1:0] control;
    
    // Create shift register out of control
    always @(posedge prog_clk) begin
        if (prog_en == 1)
            prog_control <= { prog_control[NUM_BITS - 2:0], prog_in };
    end
    
    always @(negedge prog_en) begin
        control <= prog_control;
    end
    
    // Keep chain of shift registers going to next CLB
    assign prog_out = prog_control[NUM_BITS - 1];
    
    genvar index;
    generate
    for (index=0; index < WIDTH; index=index+1) begin
        assign l[index] = control[1 + (index * 2):(index * 2)] == 2'd0 ? 1'bz :
                          control[1 + (index * 2):(index * 2)] == 2'd1 ? r[index] :
                          control[1 + (index * 2):(index * 2)] == 2'd2 ? t[index] :
                          b[index];
                          
        assign t[index] = control[1 + (index * 2) + (WIDTH * 2):(index * 2) + (WIDTH * 2)] == 2'd0 ? 1'bz :
                          control[1 + (index * 2) + (WIDTH * 2):(index * 2) + (WIDTH * 2)] == 2'd1 ? b[index] :
                          control[1 + (index * 2) + (WIDTH * 2):(index * 2) + (WIDTH * 2)] == 2'd2 ? l[index] :
                          r[index];
                          
        assign r[index] = control[1 + (index * 2) + (WIDTH * 4):(index * 2) + (WIDTH * 4)] == 2'd0 ? 1'bz :
                          control[1 + (index * 2) + (WIDTH * 4):(index * 2) + (WIDTH * 4)] == 2'd1 ? t[index] :
                          control[1 + (index * 2) + (WIDTH * 4):(index * 2) + (WIDTH * 4)] == 2'd2 ? b[index] :
                          l[index];
                          
        assign b[index] = control[1 + (index * 2) + (WIDTH * 6):(index * 2) + (WIDTH * 6)] == 2'd0 ? 1'bz :
                          control[1 + (index * 2) + (WIDTH * 6):(index * 2) + (WIDTH * 6)] == 2'd1 ? l[index] :
                          control[1 + (index * 2) + (WIDTH * 6):(index * 2) + (WIDTH * 6)] == 2'd2 ? r[index] :
                          t[index];
    end
    endgenerate
    
endmodule
