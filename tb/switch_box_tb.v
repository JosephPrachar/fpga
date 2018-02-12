`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/14/2017 11:04:37 PM
// Design Name: 
// Module Name: prog_mux16_tb
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


module switch_box_tb();
    reg prog_in;
    reg prog_clk;
    reg prog_en;
    wire prog_out;
    
    reg [23:0] settings;
    reg [23:0] last_settings;
    integer i;
    
    wire [2:0] left;
    wire [2:0] top;
    wire [2:0] right;
    wire [2:0] bottom;
    reg [2:0] left_reg;
    reg [2:0] top_reg;
    reg [2:0] right_reg;
    reg [2:0] bottom_reg;
    assign left = left_reg;
    assign top = top_reg;
    assign right = right_reg;
    assign bottom = bottom_reg;

    disjoint_switch #(3) switch_i(
        .prog_in(prog_in),
        .prog_clk(prog_clk),
        .prog_en(prog_en),
        .l(left),
        .r(right),
        .t(top),
        .b(bottom),
        .prog_out(prog_out)
    );

    initial begin
        // Clear all values
        prog_in = 0;
        prog_clk = 0;
        prog_en = 0;
        program(24'h0, 24'h0);
        settings = 24'h0;
        last_settings = 24'h0;
        left_reg = 4'dz;
        top_reg = 4'dz;
        right_reg = 4'dz;
        bottom_reg = 4'dz;
        #20
        
        settings = 24'b000000010101010101000000;
        program(settings, last_settings);
        
        #100
        bottom_reg = 3'b111;
        assert(top == bottom_reg);
        
        #20
        left_reg = 3'b111;
        assert(right == left_reg);

        $display("prog_mux16 test ran with no errors");
        $finish;
    end
    
    task program (input [23:0] new_settings, input [23:0] old_settings);
        integer i;
        begin
            prog_clk = 0;
            prog_en = 1;
            for (i = 0; i < 24; i = i + 1) begin
                // First verify that the correct value is being fed to next string of
                // shift registers
                assert(prog_out == old_settings[i]);
                
                // Shift in new settings value
                #1 prog_in = new_settings[i];
                #1 prog_clk = 1;
                #1 prog_clk = 0;
            end
            prog_en = 0;
        end
    endtask
    
    task assert(input condition);
        if(!condition) begin
            $display("ERROR at time ", $time);
            $finish(2);
        end
    endtask
endmodule
