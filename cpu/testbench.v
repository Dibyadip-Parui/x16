`timescale 1ns/1ps

`include "cpu/cpu.v"
`include "cpu/alu.v"
`include "cpu/reg.v"
`include "cpu/cu.v"

module top;
    reg clk = 0;
    reg rst = 1;
    wire [15:0] rom_addr;
    wire [15:0] rom_data;

    wire [15:0] gpo; //this wire is directly conected to r2 as a general purpose output

    CPU cpu (
        .clk(clk),
        .rst(rst),
        .rom_addr(rom_addr),
        .rom_data(rom_data),
        .gpo(gpo)
    );

    rom16 rom (
        .addr(rom_addr),
        .data(rom_data)
    );


    //clock generation
    always #5 clk = ~clk;

    initial begin

        $dumpfile("sim.vcd");
        $dumpvars(0, top);

        #20 rst = 0;
        #500 $finish;
    end
    initial begin
        $monitor("R2 = %h IP = %h time = %t", gpo, rom_addr, $time);
    end

endmodule

module rom16(
    input wire [15:0] addr,
    output reg [15:0]data
);

reg [15:0] mem [0:256];

initial begin
    $readmemh("asm/prog.hex", mem);
end

always @(*) begin
    data = mem[addr];
end
endmodule