module adder(a, b, out);
    input [3:0] a;
    input [3:0] b;
    output [4:0] out;

    assign out = {1'd0, a} + {1'd0, b};
endmodule
