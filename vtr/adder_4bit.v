module adder(a, b, out);
    input [1:0] a;
    input [1:0] b;
    output [2:0] out;

    assign out = {1'd0, a} + {1'd0, b};
endmodule
