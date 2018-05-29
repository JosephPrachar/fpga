module multi_reg(D, Q, clk, en, en2);
    input clk, en, en2;
    input [3:0] D;
    output [3:0] Q;
    reg [3:0] d2;

    always @(posedge clk)
        if (en)
            d2 <= D;
        else if (en2)
            Q <= d2;

endmodule
