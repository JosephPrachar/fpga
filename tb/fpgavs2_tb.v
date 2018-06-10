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
    
    reg [4:0] a, b;
    wire [3:0] a_w, b_w;
    reg set, clear;
    wire s_w ,c_w;
    reg reset, seq_in;
    wire r_w, seq_w;
    
    
    wire [6:0] led_out;
    reg [3:0] state;
    wire q;
    wire [4:0] out;
    wire [6:0] correct;
    
    assign s_w = set;
    assign c_w = clear;
    assign r_w = reset;
    assign seq_w = seq_in;
    assign a_w = a[3:0];
    assign b_w = b[3:0];
    
    
    
    wire nc_1;
    wire [9:0] nc_10;
    
    reg [1479:0] settings;
    reg [1479:0] last_settings;
    integer i;
    
    fpgav2 lc(
        .prog_in(prog_in),
        .prog_clk(prog_clk),
        .prog_en(prog_en),
        .io({ led_out[0], nc_1, nc_1, led_out[4], r_w, 
              led_out[3], nc_1, nc_1, nc_1, led_out[2],
              led_out[5], nc_1, nc_1, seq_w, led_out[1],
              led_out[6], nc_1, nc_1, nc_1, nc_1}),

        .clk(clk),
        .prog_out(prog_out));
      Sequence_Detector_MOORE_Verilog tb(
        .clock(clk),
        .reset(r_w), // reset input
        .sequence_in(seq_w), // binary input
        .LED_out(correct)      
            );
//                .io({ nc_1, nc_1, nc_1, nc_1, nc_1, 
//              nc_1, nc_1, nc_1, nc_1, nc_1,
//              nc_1, nc_1, nc_1, nc_1, nc_1,
//              nc_1, nc_1, nc_1, nc_1, nc_1}),
//        .io({ nc_1, nc_1, nc_1, nc_1, q, 
//      nc_1, nc_1, s_w, nc_1, nc_1,  ff test
//      nc_1, nc_1, nc_1, nc_1, nc_1,
//      nc_1, nc_1, nc_1, c_w, nc_1}),

//                .io({ b_w[3], nc_1, out[4], out[0], a_w[3], 
//              nc_1, out[3], nc_1, out[2], nc_1, 4 bit adder
//              nc_1, nc_1, out[1], b_w[0], a_w[0],
//              b_w[1], b_w[2], nc_1, a_w[1], a_w[2]}),
//                .io({ a_wire[0], b_wire[1], nc_1, nc_1, out[0], 3 bit adder
//              out[3], nc_1, nc_1, nc_1, nc_1,
//              nc_1, nc_1, a_wire[1], out[1], b_wire[2],
//              nc_1, nc_1, b_wire[0], out[2], a_wire[2]}),
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
        settings = 1480'b0000000001000000001000000000000000000000000001000000000000001000000000000000000000000000000000000000000000000000000000000000100000101000111100100000100000000000000000000000000001000000001000000001000000000000010000000101101000000001010000000000000000100111100011110010001101000000001001111000110111110010001011000000111110100101111010101111100101000100010001000100000111111110011111100001000000010000000001100010010000000100011001010001000001000101101100000110110010011000010010011101000101001001110100010000101010001010100010100010101000100010001000000010000000011000000010000000001100001001000010000100000000000000010100000000000000000000000000000000000001000000000000000000000011001000000000010100000100010010101001001000001001111010100000111010101001000010101110100100001110101011001001000100110001001100001110101011101010000001010000010100000010000000100000000010111110101111110001000101010100000100000000000000000000000000011111100110011000001000000000000000100000000000000010000111110111100110010100000000000000000000001111101101101001110110011000000110011000001000000000000000010001010100010000010000000000000000000000000000000000000010000000000000000000000000000000011000101000000001110110000000000101001111110001010001011110100110111111010100010010001000100010000000010001000100010001111011101110111000100010101010101000101001101000011010000000000000000000001010000010001110000000000000100000111100001100111011010000000000000000000000000000000000000000000000000000000000;
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

                
//        clear = 0;
//        set = 0;
//        # 5 clk = ~clk;
//        # 5 clk = ~clk;
//        #200
//        set = 1;
//        # 5 clk = ~clk;
//        # 5 clk = ~clk;
//        #200
//        set = 0;
//        # 5 clk = ~clk;
//        # 5 clk = ~clk;
//        #200
//        clear = 1;
//        # 5 clk = ~clk;
//        # 5 clk = ~clk;
//        #200
//        clear = 0;
//        # 5 clk = ~clk;
//        # 5 clk = ~clk;
//        #2000
        
        
        
//        a = 5'd0;
//        b = 5'd0;
//        for (a = 5'd0; a < 16; a = a + 1)
//            for (b = 0; b < 16; b = b + 1) begin
//                correct = a + b;
//                #5 assert(correct == out);
//                #5;
//            end
                
        $display("prog_mux16 test ran with no errors");
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
