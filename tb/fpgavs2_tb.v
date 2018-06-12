`timescale 1ns / 1ps

module fpgavs2_tb();
    reg prog_in;
    reg prog_clk;
    reg prog_en;
    
    reg clk;
    wire prog_out;
    
    reg reset, seq_in;
    wire r_w, seq_w;
    
    wire [6:0] led_out;
    reg [3:0] state;
    wire [6:0] correct;

    assign r_w = reset;
    assign seq_w = seq_in;
    
    wire nc_1;
    wire [9:0] nc_10;
    
    reg [1479:0] settings;
    reg [1479:0] last_settings;
    integer i;
    
    fpgav2 fpga(
        .prog_in(prog_in),
        .prog_clk(prog_clk),
        .prog_en(prog_en),
        .io({ led_out[0], nc_1, nc_1, led_out[4], r_w, 
              led_out[3], nc_1, nc_1, nc_1      , led_out[2],
              led_out[5], nc_1, nc_1, seq_w     , led_out[1],
              led_out[6], nc_1, nc_1, nc_1      , nc_1}),

        .clk(clk),
        .prog_out(prog_out));
        
      Sequence_Detector_MOORE_Verilog tb(
        .clock(clk),
        .reset(r_w), // reset input
        .sequence_in(seq_w), // binary input
        .LED_out(correct));
        
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
        settings = 1480'b0000000001000000001000000000000000000000000001000000000000000000000000000000000001000000000000000000000000000000000000000001000000001111001011001011100000000000000000000000000001000000001110000000000000110000101000000100000101010000000001000100110000100000100101000000101000010100001000001001010000010100101000101001010010100010100100000001000000000000101000001010000011101011111010110000110000000100000000011000010010000100010010001011111101101001010001011111000010011000011111000111011011000001011011011110000001100010000111111110011111100001000000010000000001011100001111111100010001001000000010000110000000000000010000000000000000000000000000000000000000000000000001000000000000011000000000010100000000000000000000000000000000000000000000001010000000000000000000000000000101001010000000000000000000000000000000000000000000000100010001000100000000000000000000000001110101011101010001000001000001010100000000000000000000000110000110000000000110001000000010000000000000000000000000000011000011111011101010000010000000000000011100011001111101010110000111100000000110000000000010000000000100000100010101010000000000000000000000000000000000000011000000000000000000000000000000001010011111001110001110111101011010101110011101011100001010010010101011100111010111111011011100100010101000100010000011011101111111011000010011000000100000101001101000011010000100000000010000000000001010001001000000000000110010110010001111000000000011000000000000000000000000000000000000000000000000000000;
        program(settings, last_settings);
        last_settings = settings;
        clk = 0;
        seq_in = 0;
        reset = 0;
        #300
        reset = 1;

        #300
        reset = 0;
        seq_in = 1;
        #40
        seq_in = 0;
        #40 
        seq_in = 1;
        #40       
        seq_in = 1;
        #40
        seq_in = 0;
        #40
        seq_in = 0;
        #40
        seq_in = 1;
        #40 
        seq_in = 0;
        #40       
        seq_in = 0;
        #40
        seq_in = 1;
        #400
        
        reset = 0;
        seq_in = 1;
        #40
        seq_in = 0;
        #40 
        seq_in = 1;
        #40       
        seq_in = 1;
        #40
        seq_in = 0;
        #40
        reset = 1;
        seq_in = 1;
        #40
        seq_in = 1;
        #40 
        seq_in = 0;
        #40       
        seq_in = 0;
        #40
        seq_in = 1;
        #40 
        seq_in = 0;
        #40       
        seq_in = 0;
        #40
        seq_in = 0;
        #400
        $finish;
    end
    
    always
        #20 clk = ~clk;
    
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
    
    always @(led_out)
    begin
        case (led_out)
         7'b0000001: state = 4'b0000; // "0"                                                                           
         7'b1001111: state = 4'b0001; // "1"                                                                           
         7'b0010010: state = 4'b0010; // "2"                                                                           
         7'b0000110: state = 4'b0011; // "3"                                                                           
         7'b1001100: state = 4'b0100; // "4"                                                                           
         7'b0100100: state = 4'b0101; // "5"                                                                           
         7'b0100000: state = 4'b0110; // "6"                                                                           
         7'b0001111: state = 4'b0111; // "7"                                                                           
         7'b0000000: state = 4'b1000; // "8"                                                                           
         7'b0000100: state = 4'b1001; // "9"                                                                           
         default:  state = 4'hF;
         endcase
    end
endmodule
