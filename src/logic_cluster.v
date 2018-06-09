`timescale 1ns / 1ps

module logic_cluster #(parameter NUM_BLE = 5, parameter NUM_INPUTS = 11)( // these should add to a nice power of two
    input prog_in,
    input prog_clk,
    input prog_en,
    input [NUM_INPUTS - 1:0] in,
    input clk,
    output [NUM_BLE - 1:0] out,
    output prog_out
    );
    
    wire [NUM_BLE * 4 - 1:0] ble_inputs;
    
    wire [NUM_BLE - 1:0] ble_outputs;
    wire [NUM_BLE + 1:0] prog_connect;
    assign prog_connect[0] = prog_in;
    assign prog_out = prog_connect[NUM_BLE + 1];
    
    assign out = ble_outputs;
    
    connection_box interconnect(
        .prog_in(prog_in),
        .prog_clk(prog_clk),
        .prog_en(prog_en),
        .in({ble_outputs, in[9:0], 1'd0}),
        .prog_out(prog_connect[1]),
        .out(ble_inputs));  
    
    genvar index;
    generate
    for (index=0; index < NUM_BLE; index=index+1) begin
        logic_element ble_i(
        .prog_in(prog_connect[index + 1]),
        .prog_clk(prog_clk),
        .prog_en(prog_en),
        .clk(clk),
        .in(ble_inputs[index * 4 + 3: index * 4]),
        .prog_out(prog_connect[index + 2]),
        .out(ble_outputs[index]));
    end
    endgenerate

endmodule
