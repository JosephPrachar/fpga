`timescale 1ns / 1ps

module fpgav2(
    input prog_in,
    input prog_clk,
    input prog_en,
    input clk,
    inout [19:0] io,
    output prog_out
    );
    
    wire [10:0] lc_inputs;
    wire [4:0] lc_outputs;
    wire [24:0] prog_connection;
    assign prog_out = prog_connection[24];
    
    wire [4:0] north_i_bus;
    wire [4:0] east_i_bus;
    wire [4:0] south_i_bus;
    wire [4:0] west_i_bus;
    wire [4:0] north_o_bus;
    wire [4:0] east_o_bus;
    wire [4:0] south_o_bus;
    wire [4:0] west_o_bus;
    
    wire [9:0] north_pre_io;
    wire [9:0] south_pre_io;
    
    wire [9:0] north_bus;
    wire [9:0] east_bus;
    wire [9:0] south_bus;
    wire [9:0] west_bus;
    
    wire [9:0] nw_bus;
    wire [9:0] ne_bus;
    wire [9:0] sw_bus;
    wire [9:0] se_bus;
    
    wire [9:0] nw_logic_in;
    wire [4:0] nw_logic_out;
    wire [9:0] ne_logic_in;
    wire [4:0] ne_logic_out;
    wire [9:0] sw_logic_in;
    wire [4:0] sw_logic_out;
    wire [9:0] se_logic_in;
    wire [4:0] se_logic_out;
    
    wire [9:0] high_z;
    assign high_z = prog_en == 0 ? 10'dz : 0;
    
    io_bank #(5) north_bank(
        .prog_in(prog_in),
        .prog_clk(prog_clk),
        .prog_en(prog_en),
        .io_pad(io[4:0]),
        .from_pad(north_i_bus),
        .to_pad(north_o_bus),
        .prog_out(prog_connection[0])
    );
    io_bank #(5) east_bank(
        .prog_in(prog_connection[0]),
        .prog_clk(prog_clk),
        .prog_en(prog_en),
        .io_pad(io[9:5]),
        .from_pad(east_i_bus),
        .to_pad(east_o_bus),
        .prog_out(prog_connection[1])
    );
    io_bank #(5) south_bank(
        .prog_in(prog_connection[1]),
        .prog_clk(prog_clk),
        .prog_en(prog_en),
        .io_pad(io[14:10]),
        .from_pad(south_i_bus),
        .to_pad(south_o_bus),
        .prog_out(prog_connection[2])
    );
    io_bank #(5) west_bank(
        .prog_in(prog_connection[2]),
        .prog_clk(prog_clk),
        .prog_en(prog_en),
        .io_pad(io[19:15]),
        .from_pad(west_i_bus),
        .to_pad(west_o_bus),
        .prog_out(prog_connection[3])
    );
    
    connection_box #(3, 8, 10) west_input_cb (
        .prog_in(prog_connection[3]),
        .prog_clk(prog_clk),
        .prog_en(prog_en),
        .in({ high_z[2:1], west_i_bus, high_z[0]}),
        .prog_out(prog_connection[4]),
        .out(sw_bus)
        );
    disjoint_switch #(10) west_switch(
            .prog_in(prog_connection[4]),
            .prog_clk(prog_clk),
            .prog_en(prog_en),
            .l(high_z[9:0]),
            .r(west_bus),
            .t(nw_bus),
            .b(sw_bus),
            .prog_out(prog_connection[5])
        );
    connection_box #(4, 16, 5) west_output_cb (
            .prog_in(prog_connection[5]),
            .prog_clk(prog_clk),
            .prog_en(prog_en),
            .in({high_z[5:1], nw_bus, high_z[0]}),
            .prog_out(prog_connection[6]),
            .out(west_o_bus)
            );
            
    connection_box #(3, 8, 10) sw_cb (
            .prog_in(prog_connection[6]),
            .prog_clk(prog_clk),
            .prog_en(prog_en),
            .in({high_z[2:1], sw_logic_out, high_z[0]}),
            .prog_out(prog_connection[7]),
            .out(sw_bus)
            );
            
    connection_box #(3, 8, 10) nw_cb (
            .prog_in(prog_connection[7]),
            .prog_clk(prog_clk),
            .prog_en(prog_en),
            .in({high_z[2:1], nw_logic_out, high_z[0]}),
            .prog_out(prog_connection[8]),
            .out(nw_bus)
            );
            
    logic_cluster nw_logic(
        .prog_in(prog_connection[8]),
        .prog_clk(prog_clk),
        .prog_en(prog_en),
        .in({1'dz, nw_logic_in}),
        .clk(clk),
        .out(nw_logic_out),
        .prog_out(prog_connection[9])
        );
        
    logic_cluster sw_logic(
        .prog_in(prog_connection[9]),
        .prog_clk(prog_clk),
        .prog_en(prog_en),
        .in({1'dz, sw_logic_in}),
        .clk(clk),
        .out(sw_logic_out),
        .prog_out(prog_connection[10])
        );
        
    connection_box #(4, 16, 5) south_output_cb (
        .prog_in(prog_connection[10]),
        .prog_clk(prog_clk),
        .prog_en(prog_en),
        .in({high_z[5:1], south_pre_io, high_z[0]}),
        .prog_out(prog_connection[11]),
        .out(south_o_bus)
        );
                
    connection_box #(3, 8, 10) south_input_cb (
        .prog_in(prog_connection[11]),
        .prog_clk(prog_clk),
        .prog_en(prog_en),
        .in({high_z[2:1], south_i_bus, high_z[0]}),
        .prog_out(prog_connection[12]),
        .out(south_pre_io)
        );
        
    connection_box #(3, 8, 10) east_input_cb (
        .prog_in(prog_connection[12]),
        .prog_clk(prog_clk),
        .prog_en(prog_en),
        .in({high_z[2:1], east_i_bus, high_z[0]}),
        .prog_out(prog_connection[13]),
        .out(se_bus)
        );
    connection_box #(3, 8, 10) se_cb (
        .prog_in(prog_connection[13]),
        .prog_clk(prog_clk),
        .prog_en(prog_en),
        .in({high_z[2:1], se_logic_out, high_z[0]}),
        .prog_out(prog_connection[14]),
        .out(se_bus)
        );
        
    logic_cluster se_logic(
        .prog_in(prog_connection[14]),
        .prog_clk(prog_clk),
        .prog_en(prog_en),
        .in({1'dz, se_logic_in}),
        .clk(clk),
        .out(se_logic_out),
        .prog_out(prog_connection[15])
        );
        
    disjoint_switch #(10) south_switch(
        .prog_in(prog_connection[15]),
        .prog_clk(prog_clk),
        .prog_en(prog_en),
        .l(sw_logic_in),
        .r(se_logic_in),
        .t(south_bus),
        .b(south_pre_io),
        .prog_out(prog_connection[16])
        );
    disjoint_switch #(10) central_switch(
        .prog_in(prog_connection[16]),
        .prog_clk(prog_clk),
        .prog_en(prog_en),
        .l(west_bus),
        .r(east_bus),
        .t(north_bus),
        .b(south_bus),
        .prog_out(prog_connection[17])
        );
            
    disjoint_switch #(10) north_switch(
        .prog_in(prog_connection[17]),
        .prog_clk(prog_clk),
        .prog_en(prog_en),
        .l(nw_logic_in),
        .r(ne_logic_in),
        .t(north_pre_io),
        .b(north_bus),
        .prog_out(prog_connection[18])
        );
    connection_box #(4, 16, 5) north_output_cb (
        .prog_in(prog_connection[18]),
        .prog_clk(prog_clk),
        .prog_en(prog_en),
        .in({high_z[5:1], north_pre_io, high_z[0]}),
        .prog_out(prog_connection[19]),
        .out(north_o_bus)
        );
                    
    connection_box #(3, 8, 10) north_input_cb (
        .prog_in(prog_connection[19]),
        .prog_clk(prog_clk),
        .prog_en(prog_en),
        .in({high_z[2:1], north_i_bus, high_z[0]}),
        .prog_out(prog_connection[20]),
        .out(north_pre_io)
        );                        
    logic_cluster ne_logic(
        .prog_in(prog_connection[20]),
        .prog_clk(prog_clk),
        .prog_en(prog_en),
        .in({1'dz, ne_logic_in}),
        .clk(clk),
        .out(ne_logic_out),
        .prog_out(prog_connection[21])
        );
        
    connection_box #(3, 8, 10) ne_cb (
        .prog_in(prog_connection[21]),
        .prog_clk(prog_clk),
        .prog_en(prog_en),
        .in({high_z[2:1], ne_logic_out, high_z[0]}),
        .prog_out(prog_connection[22]),
        .out(ne_bus)
        );
        
    connection_box #(4, 16, 5) east_output_cb (
        .prog_in(prog_connection[22]),
        .prog_clk(prog_clk),
        .prog_en(prog_en),
        .in({high_z[5:1], ne_bus, high_z[0]}),
        .prog_out(prog_connection[23]),
        .out(east_o_bus)
        );
                
    disjoint_switch #(10) east_switch(
        .prog_in(prog_connection[23]),
        .prog_clk(prog_clk),
        .prog_en(prog_en),
        .l(east_bus),
        .r(high_z[9:0]),
        .t(ne_bus),
        .b(se_bus),
        .prog_out(prog_connection[24])
        );
endmodule
