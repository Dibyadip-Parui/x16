`include "cpu/cu.v"
`include "cpu/alu.v"

module CPU(
    input wire rst,
    input wire clk,
    input wire [15:0] rom_data,
    output wire [15:0] rom_addr
);

    wire [15:0] data; //Main data bus
    wire count; //the wire that tells the IP to count

    //Register control
    wire [3:0] WR;
    wire WR_EN;
    wire [3:0] ALU1;
    wire ALU1_EN;
    wire [3:0] ALU2;
    wire ALU2_EN;
    
    wire [15:0] out1;
    wire [15:0] out2;
    wire [15:0] out1_p; //this output comes fomr mux1 and goes to .a in alu1

    //ALU
    wire [3:0] ALU;
    wire [15:0] ALU_OUT;
    wire ALU_EN;
    wire IN_S;
    wire Cin;
    wire Cout;

    RegF reg1 (.clk(clk), .rst(rst), .in(ALU_OUT), .addr(rom_addr), 
               .count(count), 
               .WR(WR), .WR_EN(WR_EN), 
               .ALU1(ALU1), .ALU1_EN(ALU1_EN),
               .ALU2(ALU2), .ALU2_EN(ALU2_EN),
               .out1(out1), .out2(out2)
               );

    CU core1  (.clk(clk), .rst(rst), .ins(rom_data), .data(data),
               .count(count), 
               .WR(WR), .WR_EN(WR_EN), 
               .ALU1(ALU1), .ALU1_EN(ALU1_EN),
               .ALU2(ALU2), .ALU2_EN(ALU2_EN),
               .ALU(ALU), .ALU_EN(ALU_EN), .IN_S(IN_S)
               );

    ALU16 alu1 (.a(out1_p), .b(out2), .Cin(Cin), 
                .S(ALU), .EN(ALU_EN), .out(ALU_OUT),
                .Cout(Cout)
                );
    
    MUX16_2t1 mux1 (.a(data), .b(out1), .S(IN_S), .out(out1_p));

endmodule


//Ai generated i dont know about rom simulation in verilog
module rom(
    input wire clk,
    input wire rst,
    input wire [15:0] addr,
    output reg [15:0] data
);

    reg [15:0] rom_mem [0:32];

    // Load the hex file at simulation start
    initial begin
        $readmemh("prog.hex", rom_mem);
    end

    // Synchronous read with reset
    always @(posedge clk) begin
        if (rst) begin
            data <= 16'h0000;
        end else begin
            // Map the 16-bit address to the 4-entry ROM using lower 2 bits
            data <= rom_mem[addr[4:0]];
        end
    end
endmodule