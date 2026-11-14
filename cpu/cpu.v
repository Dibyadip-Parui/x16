
module CPU(
    input wire rst,
    input wire clk,
    input wire [15:0] data,
    output reg [15:0] data_out,
    output reg [15:0] addr,
    output wire [15:0] gpo,
    output wire load,
    output wire store
);

    wire [15:0] data_bus; //Main data bus
    wire count; //the wire that tells the IP to count

    //Register control
    wire [3:0] WR;
    wire WR_EN;
    wire [3:0] ALU1;
    wire ALU1_EN;
    wire [3:0] ALU2;
    wire ALU2_EN;

    reg [15:0] rom_data;
    wire [15:0] rom_addr;

    wire jmp;
    
    wire [15:0] out1;
    wire [15:0] out2;
    wire [15:0] aluIn1;
    wire [15:0] aluIn2;

    //ALU
    wire [3:0] ALU;
    wire [15:0] ALU_OUT;
    wire ALU_EN;
    wire IN_S;
    wire Cin;
    wire Cout;
    reg wrEN;
    reg wrRen;
    wire eq;
    wire ab;
    wire be;

    reg [15:0] regIn;

    always @(*) begin
        if (wrEN) begin
            wrRen = WR_EN;
        end 
        else begin
            wrRen = 0;
        end
    end

    RegF reg1 (.clk(clk), .rst(rst), .in(regIn), .addr(rom_addr), 
               .count(count), .addr_in(data_bus), 
               .WR(WR), .WR_EN(wrRen), 
               .ALU1(ALU1), .ALU1_EN(ALU1_EN),
               .ALU2(ALU2), .ALU2_EN(ALU2_EN),
               .out1(out1), .out2(out2),
               .gpo(gpo),
               .jmp(jmp));

    CU core1  (.clk(clk), .rst(rst), .ins(rom_data), .data(data_bus),
               .count(count), 
               .WR(WR), .WR_EN(WR_EN), 
               .ALU1(ALU1), .ALU1_EN(ALU1_EN),
               .ALU2(ALU2), .ALU2_EN(ALU2_EN),
               .ALU(ALU), .ALU_EN(ALU_EN), .IN_S(IN_S),
               .jmp(jmp), .eq(eq), .ab(ab), .be(be), .carry(Cout),
               .load(load), .store(store)
               );

    ALU16 alu1 (.a(aluIn1), .b(aluIn2), .Cin(Cin), 
                .S(ALU), .EN(ALU_EN), .out(ALU_OUT),
                .Cout(Cout), .clk(clk),
                .eq(eq), .ab(ab), .be(be));

    MUX16_2t1 mux1 (.out1(out1), .out2(out2),
                    .data(data_bus), .IN_S(IN_S),
                    .aluIn1(aluIn1), .aluIn2(aluIn2));
    
    always @(*) begin
        if (load) begin
            addr = out2;
            regIn = data;
        end
        else 
        if (store) begin
            addr = out2;
            data_out = out1;
        end
        else begin
            addr = rom_addr;
            rom_data = data;
            regIn = ALU_OUT;
        end
    end

    always @(*) begin
        if (ALU==4'b0111) begin
            wrEN = 0;
        end
        else begin
            wrEN = 1;
        end
    end

endmodule