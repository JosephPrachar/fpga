module adder(clk, set, clear, q);
    input clk;
    input set;
    input clear;
    output q;

    reg bit = 0;

    assign q = bit;

    always @(posedge clk) begin
        if (set)
            bit <= 1;
        else if (clear)
            bit <= 0;
    end

endmodule
