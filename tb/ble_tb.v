`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/30/2017 10:08:58 PM
// Design Name: 
// Module Name: ble_tb
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


module ble_tb();    
    reg prog_in;
    reg prog_clk;
    reg prog_en;
    
    reg clk;
    reg [3:0] in;
    wire prog_out;
    wire out;
    
    reg [18:0] settings;
    reg [18:0] last_settings;
    integer i;
    
    logic_element ble_i(
        .prog_in(prog_in),
        .prog_clk(prog_clk),
        .prog_en(prog_en),
        .clk(clk),
        .in(in),
        .prog_out(prog_out),
        .out(out)
    );
    
    initial begin
        // Clear all values
        in = 0;
        clk = 0;
        prog_in = 0;
        prog_clk = 0;
        prog_en = 0;
        program_mux(19'h0, 19'h0);
        settings = 19'h0;
        last_settings = 19'h0;
        #20

        // Puts 0xAA in lut; all control signals are zero
        // Generated with bitgen tool
        settings = 19'b1010101010101010000;
        program_mux(settings, last_settings);
        
        // loop through all combinations
        for (i = 0; i < 'h10; i = i + 1) begin
            #5 in <= i;
            // Add some rising edges to ensure they dont affect the circuit
            clk <= ~clk;
        end
        
        last_settings = settings;
        // Puts 0xF0 in lut; all control signals are zero
        // Generated with bitgen tool
        settings = 19'b1111111100000000000;
        program_mux(settings, last_settings);
        
        // loop through all combinations
        for (i = 0; i <= 'h10; i = i + 1) begin
            #5 in <= i;
            // Add some rising edges to ensure they dont affect the circuit
            clk <= ~clk;
        end

        $display("prog_mux16 test ran with no errors");
        $finish;
    end
    
    task program_mux (input [18:0] new_settings, input [18:0] old_settings);
        integer i;
        begin
            prog_clk = 0;
            prog_en = 1;
            for (i = 0; i < 19; i = i + 1) begin
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
