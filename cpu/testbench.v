`timescale 1ns/1ps

`include "cpu/cpu.v"
`include "cpu/alu.v"
`include "cpu/reg.v"
`include "cpu/cu.v"

module top;
    reg clk = 0;
    reg rst = 1;
    wire [15:0] addr;
    reg [15:0] data;
    reg [15:0] addr1;
    wire [15:0] data1;
    reg [15:0] addr2;
    wire [15:0] data2;
    wire load;
    wire store;
    reg EN;
    wire [15:0] data_out;

    wire [15:0] gpo; //this wire is directly conected to r2 as a general purpose output

    CPU cpu (
        .clk(clk),
        .rst(rst),
        .addr(addr),
        .data(data),
        .load(load),
        .store(store),
        .data_out(data_out),
        .gpo(gpo)
    );

    rom16 rom (
        .addr(addr1),
        .data(data1),
        .EN(EN)
    );

    ram16 ram (
        .addr(addr2),
        .data(data2),
        .load(load),
        .store(store),
        .data_in(data_out)
    );

    always @(*) begin
        if (addr > 255) begin
            addr2 = addr-255;
            data = data2;
            addr1 = 16'bz;
            EN=0;
        end
        else begin
            addr1 = addr;
            data = data1;
            addr2 = 16'bz;
            EN=1;
        end
    end

    //clock generation
    always #5 clk = ~clk;

    initial begin

        $dumpfile("sim.vcd");
        $dumpvars(0, top);

        #20 rst = 0;
        #2000 $finish;
    end
    initial begin
        $monitor("R2 = %h IP = %h time = %t", gpo, addr, $time);
    end

endmodule

module rom16 #(
    parameter DEPTH = 256,
    parameter WIDTH = 16
)(
    input wire [15:0] addr,
    output reg [WIDTH-1:0]data,
    input wire EN
);

reg [WIDTH-1:0] mem [0:DEPTH];

initial begin
    $readmemh("asm/prog.hex", mem);
end

always @(*) begin
    if (EN) begin
        data = mem[addr];
    end
    else begin
        data = 16'bz;
    end
end
endmodule

module ram16 #(
    parameter DEPTH = 256,
    parameter WIDTH = 16
)(
    input wire [15:0] addr,
    input wire [15:0] data_in,
    output reg [15:0] data,

    input wire load,
    input wire store
);

    reg [15:0] mem [0:DEPTH];

    always @(*) begin
        if (load) begin
            data = mem[addr];
        end
        else if (store) begin
            mem[addr] = data_in;
        end
        else begin
            data = 16'bz;
        end
    end

endmodule