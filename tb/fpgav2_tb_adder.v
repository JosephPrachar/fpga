`timescale 1ns / 1ps

module fpgavs2_tb_adder();
    reg prog_in;
    reg prog_clk;
    reg prog_en;
    
    reg clk;
    wire prog_out;
    
    reg [4:0] a_r, b_r;
    wire [3:0] a, b;
    assign a = a_r;
    assign b = b_r;
    
    wire [4:0] out;
    wire [4:0] correct;
    assign correct = a_r + b_r;
    
    wire nc_1;    
    reg [1479:0] settings;
    reg [1479:0] last_settings;
    integer i;
    
    fpgav2 fpga(
        .prog_in(prog_in),
        .prog_clk(prog_clk),
        .prog_en(prog_en),
        .io({ b[3], nc_1, out[4], out[0], a[3], 
              nc_1, out[3], nc_1, out[2], nc_1,
              nc_1, nc_1, out[1], b[0], a[0],
              b[1], b[2], nc_1, a[1], a[2]}),

        .clk(clk),
        .prog_out(prog_out));
        
//      .io({ nc_1, nc_1, nc_1, nc_1, nc_1, 
//              nc_1, nc_1, nc_1, nc_1, nc_1,
//              nc_1, nc_1, nc_1, nc_1, nc_1,
//              nc_1, nc_1, nc_1, nc_1, nc_1}),

    initial begin
        // Clear all values
        prog_in = 0;
        prog_clk = 0;
        prog_en = 0;
        program(0, 0);
        settings = 0;
        last_settings = 0;
        #20
    
        // Generated with bitgen tool
        settings = 1480'b1001000001001001001000000000000000000000000001000000000001000001010001000000000000000000000000000000000000000000000000000000000010001000100011001111000000000000000000000000001110010100000000000000000000000000000000000000000000000000000110100101010000100001100000000010011100011100001001110001110000011010000101101001011010100001100110011001100110000011010010110100100000010111000101110000000000100011111000011001100110100100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100100001100000000000000000000000000000000000001000000000000010000000000000000000010100000000000000000000100000000000000000000000000000000000000000000000001000010011000000100001001100000000000000000000000000000000000000000000000000000000000000000101110001011100001101001011010010000000000000000000000000000000000000000000001100110011000000000000010000000000010000000000000000000001100000000010000000000000000000000001000000101110001000001000110011001111000011110000000000000000000000000000000000000000000001000100000001010000000000000000000000000010000001000000000000110100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000011001100001100000011000000000000001100000000000000000000000000000000000000000000;
        program(settings, last_settings);
        last_settings = settings;
        clk = 0;
        
        a_r = 0;
        b_r = 0;
        #40
        a_r = 1;
        b_r = 0;
        #40
        a_r = 0;
        b_r = 1;
        #40
        a_r = 7;
        b_r = 7;
        #40
        a_r = 15;
        b_r = 7;
        #40;
        a_r = 15;
        b_r = 15;
        #40
        
        
        
        $finish;
    end
    
    always
        #10 clk = ~clk;
    
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
