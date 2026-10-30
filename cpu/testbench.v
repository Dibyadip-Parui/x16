//THIS FILE IS ONLY TO TEST THIS PROJECT AND IS NOT A PRT OF THIS PROJECT
`timescale 10ps / 1ps

`include "cpu/cpu.v"

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