`timescale 1ns / 1ps

module io_block(
    inout fpga,
    inout io_pad,
    input prog_in,
    input prog_clk,
    input prog_en,
    output prog_out
    );
    `define DIR 0
    `define OUTPUT 0
    `define INPUT 1
    `define PULL_DOWN 1
    `define PULL_UP 2
    `define LAST 2
    
    reg [`LAST:0] prog_control;
    reg [`LAST:0] control;

    // TODO put this shift register pattern into a module
    // Create shift register out of control
    always @(posedge prog_clk) begin
        if (prog_en == 1)
            prog_control <= { prog_control[`LAST:0], prog_in };
    end
    
    always @(negedge prog_en) begin
        control <= prog_control;
    end
    
    // Keep chain of shift registers going to next CLB
    assign prog_out = prog_control[`LAST];
    
    reg fpga_wire;
    reg io_pad_wire;
    
    assign io_pad = io_pad_wire;
    assign fpga   = fpga_wire;
    
    always @(io_pad or fpga) begin
        io_pad_wire <= 1'dz;
        fpga_wire <= 1'dz;
        if (control[`DIR] == `OUTPUT)
            io_pad_wire <= fpga;
        else
            if ((control[`PULL_UP] || control[`PULL_DOWN]) && (io_pad == 1'dx || io_pad == 1'dz))
                if (control[`PULL_UP])
                    fpga_wire <= 1'd1;
                else
                    fpga_wire <= 1'd0;
            else
              fpga_wire <= io_pad;
    end
endmodule
