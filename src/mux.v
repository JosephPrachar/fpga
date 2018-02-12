`timescale 1ns / 1ps

module mux #(parameter SEL = 4) (
    input [SEL * SEL - 1:0] in,
    input [SEL - 1:0] sel,
    output out
    );
    
    genvar index;
    generate
    for (index = 0; index < SEL * SEL; index = index + 1) begin
        assign out = (sel == index) ? in[index] : 1'dz;
    end
    endgenerate
endmodule
