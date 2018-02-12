`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/14/2017 09:41:05 PM
// Design Name: 
// Module Name: mux16_tb
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


module io_tb();
    reg prog_in;
    reg prog_clk;
    reg prog_en;

    wire fpga;
    wire io_pad;
    wire out;
    reg fpga_reg;
    reg io_pad_reg;
    assign fpga = fpga_reg;
    assign io_pad = io_pad_reg;
    
    reg [2:0] settings;
    reg [2:0] last_settings;

    io_block io_i(
        .prog_in(prog_in),
        .prog_clk(prog_clk),
        .prog_en(prog_en),
        .fpga(fpga),
        .io_pad(io_pad),
        .prog_out(prog_out));
        
    initial begin
            // Clear all values
        prog_in = 0;
        prog_clk = 0;
        prog_en = 0;
        program(0, 0);
        settings = 0;
        last_settings = 0;
        fpga_reg = 'dz;
        io_pad_reg = 'dz;
        #20
        
        // programmed as input
        settings = 3'b100;
        program(settings, last_settings);
        
        #20
        assert(fpga == 'dz);
        assert(io_pad == 'dz);
        
        #20
        io_pad_reg = 1;
        assert(fpga == 1);
        
        #20
        fpga_reg = 1;
        // should see a multi driven net her
        
        #20
        fpga_reg = 'dz;
        io_pad_reg = 0;
        
        #20
        fpga_reg = 'dz;
        io_pad_reg = 'dz;
        settings = 3'b000;
        program(settings, last_settings);
        
        #20
        fpga_reg = 1;
        assert(io_pad == 1);
        
        #100

        $display("io_block test ran with no errors");
        $finish;
    end
    
    task program (input [2:0] new_settings, input [2:0] old_settings);
        integer i;
        begin
            prog_clk = 0;
            prog_en = 1;
            for (i = 0; i < 3; i = i + 1) begin
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
