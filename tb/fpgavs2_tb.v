`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/08/2018 05:27:27 PM
// Design Name: 
// Module Name: fpgavs2_tb
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



//        .io({ a_wire[2], a_wire[3], b_wire[2], b_wire[3], nc_1,
//            a_wire[1], b_wire[1], out[1]   , nc_1     , nc_1,
//            nc_1     , nc_1     , nc_1     , out[3]   , out[2],
//            b_wire[0], out[0]   , a_wire[0], nc_1     , nc_1}),
//////////////////////////////////////////////////////////////////////////////////


module fpgavs2_tb();
    reg prog_in;
    reg prog_clk;
    reg prog_en;
    
    reg clk;
    wire prog_out;
    
    reg [2:0] a, b;
    wire [1:0] a_wire, b_wire;
    wire [2:0] out;
    assign a_wire = a[1:0];
    assign b_wire = b[1:0];
    
    wire nc_1;
    wire [9:0] nc_10;
    
    reg [1479:0] settings;
    reg [1479:0] last_settings;
    integer i;
    
    fpgav2 lc(
        .prog_in(prog_in),
        .prog_clk(prog_clk),
        .prog_en(prog_en),
        .io({ a_wire[1], nc_1, nc_1, nc_1, out[0],
              nc_1, nc_1, nc_1, out[2], nc_1,
              nc_1, nc_1, b_wire[0], out[1], nc_1,
              nc_1, b_wire[1], a_wire[0], nc_1, nc_1}),

        .clk(clk),
        .prog_out(prog_out));
//            .io({ b_wire[0], nc_1, nc_1, nc_1, out[0], 2bit adder
//              nc_1, nc_1, nc_1, a_wire[1], nc_1,
//              nc_1, nc_1, b_wire[1], out[1], nc_1,
//              nc_1, nc_1, nc_1, a_wire[0], nc_1}),
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
        settings = 1480'b0000001001000000000001000000000000000000000000000000000001000000001010000000000000000000000000000000000000000000000000000000000000000010001100110000000000000000000000000001010000000000000000000000000000000000000000000000000000000000101000001000000110000000000000000000000000000000000110000100000000000101101001110010011100011000010000000000000000000000000000000000000001100110011001100000000000100011111000011001100110100100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000111000000000000000000000000000000000000000000000000000000000011000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000011000010000000000000000001000000000000000000000010000000000011000011001111000000000000000000000000000000000000000000000000000000000101000000000000000000000000000000000000000000011000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000101000000000000000000000001100000000000000001100000000000000000000000000000000000000000000000000;
        program(settings, last_settings);
        last_settings = settings;
        clk = 0;
        
        
        a = 5'd0;
        b = 5'd0;
        for (a = 5'd0; a < 4; a = a + 1)
            for (b = 0; b < 4; b = b + 1)
                #5 //assert(a[1:0] + b[1:0] == out[1:0]);
                
        $display("prog_mux16 test ran with no errors");
        $finish;
    end
    
    task program (input [1479:0] new_settings, input [1479:0] old_settings);
        integer i;
        begin
            prog_clk = 0;
            prog_en = 1;
            for (i = 0; i < 1480; i = i + 1) begin
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
