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


module prog_mux16_tb();
    reg [15:0] in;
    reg prog_in;
    reg prog_clk;
    reg prog_en;
    wire out;
    wire prog_out;
    
    reg [3:0] settings;
    reg [3:0] last_settings;
    integer i;

    prog_mux16 DUT (
        .in(in),
        .prog_in(prog_in),
        .prog_clk(prog_clk),
        .prog_en(prog_en),
        .out(out),
        .prog_out(prog_out));

    initial begin
        // Clear all values
        in = 0;
        prog_in = 0;
        prog_clk = 0;
        prog_en = 0;
        program_mux(4'h0, 4'h0);
        settings = 4'h0;
        last_settings = 4'h0;
        #20
        
        for (i = 4'h0; i <= 'hF; i = i + 1)
        begin
            settings = i;
            program_mux(settings, last_settings);
            test_mux(settings);
            last_settings = settings;
        end

        $display("prog_mux16 test ran with no errors");
        $finish;
    end
    
    task program_mux (input [3:0] new_settings, input [3:0] old_settings);
        integer i;
        begin
            prog_clk = 0;
            prog_en = 1;
            for (i = 3; i >= 0; i = i - 1) begin
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
    
    task test_mux (input [3:0] cur_settings);
        integer i;
        begin
            in = 16'h1;
            for (i = 0; i < cur_settings; i = i + 1)
                in = in << 1;
            #5 assert(out == 1);
            in = ~in;
            #5 assert(out == 0);
        end
    endtask
    
    task assert(input condition);
        if(!condition) begin
            $display("ERROR at time ", $time);
            $finish(2);
        end
    endtask
endmodule
