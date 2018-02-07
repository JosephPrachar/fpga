`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/03/2017 10:24:31 PM
// Design Name: 
// Module Name: logic_cluster_tb
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


module logic_cluster_tb();
    reg prog_in;
    reg prog_clk;
    reg prog_en;
    
    reg clk;
    reg [10:0] in;
    wire prog_out;
    wire [4:0] out;
    
    reg [174:0] settings;
    reg [174:0] last_settings;
    integer i;
    
    logic_cluster lc(
        .prog_in(prog_in),
        .prog_clk(prog_clk),
        .prog_en(prog_en),
        .in(in),
        .clk(clk),
        .out(out),
        .prog_out(prog_out));
    
    initial begin
        // Clear all values
        prog_in = 0;
        prog_clk = 0;
        prog_en = 0;
        program(0, 0);
        settings = 0;
        last_settings = 0;
        #20
    
        // 4-bit counter with enable
        // Generated with bitgen tool
        settings = 175'b0000101000000000000000000000000000000000100000000000000010000100000000000000000000100010001000100110110011001100110011010101100101011001101010101010101100110000000000000000000;
        program(settings, last_settings);
        
        clk = 0;
        in = 11'b1;
        // loop through all combinations
        for (i = 0; i < 'h30; i = i + 1) begin
            #5 clk <= ~clk;
            // Add some rising edges to ensure they dont affect the circuit
        end
        
        in = 11'b0;
        for (i = 0; i < 'h10; i = i + 1) begin
            #5 clk <= ~clk;
            // Add some rising edges to ensure they dont affect the circuit
        end
        
        in = 11'b1;
        for (i = 0; i < 'h10; i = i + 1) begin
            #5 clk <= ~clk;
            // Add some rising edges to ensure they dont affect the circuit
        end
        
        last_settings = settings;
    
        $display("prog_mux16 test ran with no errors");
        $finish;
    end
    
    task program (input [174:0] new_settings, input [174:0] old_settings);
        integer i;
        begin
            prog_clk = 0;
            prog_en = 1;
            for (i = 0; i < 175; i = i + 1) begin
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
