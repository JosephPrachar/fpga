module Seven_segment_LED_Display_Controller(
    input clk,
    input enable,
    input up,
    input down,
    output reg [6:0] LED_out,
    output reg [3:0] anode
    );

    reg [1:0] ns = 0;
    reg [1:0] ps = 0;
    reg [1:0] curnum = 0;
    reg [1:0] nextnum = 0;

    assign anode = 4'b0001;

    always @(posedge clk)
    begin
        ps <= ns;
        curnum <= nextnum;
    end

    always @(*)
    begin
        if (enable == 0)
            ns <= 0;
        else if (up == 
            
            
        nextnum = curnum + 1;
    end

    always @(*)
    begin
        case(curnum)
        4'b0000: LED_out = 7'b0000001; // "0"     
        4'b0001: LED_out = 7'b1001111; // "1" 
        4'b0010: LED_out = 7'b0010010; // "2" 
        4'b0011: LED_out = 7'b0000110; // "3" 
        4'b0100: LED_out = 7'b1001100; // "4" 
        4'b0101: LED_out = 7'b0100100; // "5" 
        4'b0110: LED_out = 7'b0100000; // "6" 
        4'b0111: LED_out = 7'b0001111; // "7" 
        4'b1000: LED_out = 7'b0000000; // "8"     
        4'b1001: LED_out = 7'b0000100; // "9" 
        4'b1010: LED_out = 7'b0001000; // "A" 
        4'b1011: LED_out = 7'b1100000; // "B" 
        4'b1100: LED_out = 7'b0110001; // "C" 
        4'b1101: LED_out = 7'b1000010; // "D" 
        4'b1110: LED_out = 7'b0110000; // "E" 
        4'b1111: LED_out = 7'b0111000; // "F" 
        endcase
    end

 endmodule
