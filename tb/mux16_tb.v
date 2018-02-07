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


module mux16_tb();
    reg [15:0] in;
    reg [3:0] sel;
    wire out;
    
    integer i, j;
    mux16 DUT(
        .in(in),
        .sel(sel),
        .out(out));
        
    initial begin
        // Opting for exaustive testing here mainly to practice for loops
        for (i=0; i <= 16'hFFFF; i = i + 16'h1)
        begin
            for (j=0; j <= 4'hF; j = j + 4'h1)
            begin
                in = i;
                sel = j;
                #1;
                assert(out == in[sel]);
            end
        end
        $display("Mux16 test ran with no errors");
        $finish;
    end
    
    task assert(input condition);
        if(!condition) begin
            $display("ERROR at time ", $time);
            $finish(2);
        end
    endtask
endmodule
