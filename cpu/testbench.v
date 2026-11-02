//THIS FILE IS ONLY TO TEST THIS PROJECT AND IS NOT A PART OF THIS PROJECT
`timescale 1ns / 1ps
`include "cpu/cpu.v"

//Ai generated i dont know about rom simulation in verilog
module rom(
    input wire clk,
    input wire rst,
    input wire [15:0] addr,
    output reg [15:0] data
);

    reg [15:0] rom_mem [0:16];

    // Load the hex file at simulation start
    initial begin
        $readmemh("prog.hex", rom_mem);
    end

    // Synchronous read with reset
    always @(posedge clk) begin
        if (rst) begin
            data <= 16'h0000;
        end else begin
            data <= rom_mem[addr[4:0]];
        end
    end
endmodule

module tb;

reg clk;
reg rst;
wire [15:0] addr;
wire [15:0] data;

rom rom1 (.clk(clk), .rst(rst), .addr(addr), .data(data));
CPU cpu1 (.rst(rst), .clk(clk), .rom_data(data), .rom_addr(addr));

// Clock generation (20ns period)
always begin
    #1 clk = ~clk;
end

initial begin
    // Initialize clock to prevent x-state propagation
    clk = 0;
    
    $dumpfile("waveform.vcd");
    $dumpvars(0, tb); // Dump all testbench and instance signals

    rst = 1;
    #2;
    rst = 0; // Release reset after one clock cycle
    
    #100;
    $finish; 
end

endmodule