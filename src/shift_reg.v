`timescale 1ns / 1ps

module shift_reg #(parameter SIZE = 1000) ( // plz dont leave uninitilized 
    input prog_in,
    input prog_clk,
    input prog_en,
    output prog_out
    );
    
    reg [SIZE - 1:0] prog_control;
    reg [SIZE - 1:0] control;

    // TODO put this shift register pattern into a module
    // Create shift register out of control
    always @(posedge prog_clk) begin
        if (prog_en == 1)
            prog_control <= { prog_control[SIZE - 2:0], prog_in };
    end
    
    always @(negedge prog_en) begin
        control <= prog_control;
    end
    
    // Keep chain of shift registers going to next CLB
    assign prog_out = prog_control[SIZE - 1];
endmodule
