`timescale 1ns / 1ps

module mux16(
    input [15:0] in,
    input [3:0] sel,
    output out
    );
    reg out_reg;
    assign out = out_reg;
    always @(sel or in) begin
        case (sel)           
        'd0 : out_reg = in[0];
        'd1 : out_reg = in[1];
        'd2 : out_reg = in[2];
        'd3 : out_reg = in[3];
        'd4 : out_reg = in[4];
        'd5 : out_reg = in[5];
        'd6 : out_reg = in[6];
        'd7 : out_reg = in[7];
        'd8 : out_reg = in[8];
        'd9 : out_reg = in[9];
        'd10 : out_reg = in[10];
        'd11 : out_reg = in[11];
        'd12 : out_reg = in[12];
        'd13 : out_reg = in[13];
        'd14 : out_reg = in[14];
        'd15 : out_reg = in[15];
        endcase
    end
endmodule
