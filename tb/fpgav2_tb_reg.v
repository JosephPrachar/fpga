`timescale 1ns / 1ps

module fpgavs2_tb_reg();
    reg prog_in;
    reg prog_clk;
    reg prog_en;
    
    reg clk;
    wire prog_out;
    
    reg set_r, clr_r;
    wire set, clr;
    assign set = set_r;
    assign clr = clr_r;
    
    wire out;
    wire correct;
    
    wire nc_1;    
    reg [1479:0] settings;
    reg [1479:0] last_settings;
    integer i;
    
    fpgav2 fpga(
        .prog_in(prog_in),
        .prog_clk(prog_clk),
        .prog_en(prog_en),
        .io({ nc_1, nc_1, nc_1, nc_1, out, 
              nc_1, nc_1, set, nc_1, nc_1,
              nc_1, nc_1, nc_1, nc_1, nc_1,
              nc_1, nc_1, nc_1, clr, nc_1}),
        .clk(clk),
        .prog_out(prog_out));
              
              
     sc_reg ut (
     .clk(clk),
     .set(set),
     .clear(clr),
     .q(correct));

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
        settings = 1480'b0001000000000000001000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001011111010000000000000000000000000000000000000000000000000000000000000000000000000000000000011101010111010100100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000001100000000000000110000000000000000000000000000000000000000000100000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
        program(settings, last_settings);
        last_settings = settings;
        clk = 0;
        set_r = 0;
        clr_r = 0;
        #40
        
        set_r = 1;
        #20
        set_r = 0;
        #40
        clr_r = 1;
        #20
        clr_r = 0;
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
