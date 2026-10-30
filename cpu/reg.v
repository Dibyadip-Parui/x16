
module RegF(
    input wire [15:0] in,

    input wire [3:0] WR,
    input wire WR_EN,
    input wire [3:0] ALU1,
    input wire ALU1_EN,
    input wire [3:0] ALU2,
    input wire ALU2_EN,
    
    input wire clk,
    input wire rst,
    input wire count,

    output wire [15:0] out1,
    output wire [15:0] out2,
    output wire [15:0] addr
    );

    wire [15:0] sv;
    DEC4B dec1 (.in(WR), .EN(WR_EN), .out(sv));

    wire [15:0] a1;
    DEC4B dec2 (.in(ALU1), .EN(ALU1_EN), .out(a1));

    wire [15:0] a2;
    DEC4B dec3 (.in(ALU2), .EN(ALU2_EN), .out(a2));

    Reg16_0 r0 (.in(in), .clk(clk), .rst(rst), .sv(sv[0]), .read1(a1[0]), .read2(a2[0]), .out1(out1), .out2(out2));
    counter r1 (.a(in), .rst(rst), .clk(clk), .EN(count), .addr(addr), .jmp(sv[1]), .read1(a1[1]), .read2(a2[1]), .out1(out1), .out2(out2));
    Reg16 r2 (.in(in), .clk(clk), .rst(rst), .sv(sv[2]), .read1(a1[2]), .read2(a2[2]), .out1(out1), .out2(out2));
    Reg16 r3 (.in(in), .clk(clk), .rst(rst), .sv(sv[3]), .read1(a1[3]), .read2(a2[3]), .out1(out1), .out2(out2));
    Reg16 r4 (.in(in), .clk(clk), .rst(rst), .sv(sv[4]), .read1(a1[4]), .read2(a2[4]), .out1(out1), .out2(out2));
    Reg16 r5 (.in(in), .clk(clk), .rst(rst), .sv(sv[5]), .read1(a1[5]), .read2(a2[5]), .out1(out1), .out2(out2));
    Reg16 r6 (.in(in), .clk(clk), .rst(rst), .sv(sv[6]), .read1(a1[6]), .read2(a2[6]), .out1(out1), .out2(out2));
    Reg16 r7 (.in(in), .clk(clk), .rst(rst), .sv(sv[7]), .read1(a1[7]), .read2(a2[7]), .out1(out1), .out2(out2));

endmodule

module Reg16$(
    input wire [15:0] in,
    input wire sv,
    input wire clk,
    input wire rst,
    input wire read,
    output wire [15:0] out
    );
    reg [15:0] r;
    always @(posedge clk) begin

        if (rst) begin
            r <= 16'b0;
        end
        else if (sv) begin
            r <= in;
        end
        else begin
            r <= r;
        end
    end
    assign out = r;
endmodule

module Reg16(
    input wire [15:0] in,
    input wire sv,
    input wire clk,
    input wire rst,
    input wire read1,
    input wire read2,
    output reg [15:0] out1,
    output reg [15:0] out2
    );
    reg [15:0] r;
    always @(posedge clk) begin
        if (sv) begin
            r <= in;
        end
        else begin
            r <= r;
        end
    end
    always @(*) begin
        if (rst) begin
            r <= 16'b0;
        end
    end
    always @(*) begin
        if (read1) begin
            out1 = r;
        end
        else begin
            out1 = 16'bz;
        end
    end
    always @(*) begin
        if (read2) begin
            out2 = r;
        end
        else begin
            out2 = 16'bz;
        end
    end
endmodule

module Reg16_0(
    input wire [15:0] in,
    input wire sv,
    input wire clk,
    input wire rst,
    input wire read1,
    input wire read2,
    output reg [15:0] out1,
    output reg [15:0] out2
    );

    always @(*) begin
        if (read1) begin
            out1 = 16'b0;
        end
        else begin
            out1 = 16'bz;
        end
    end
    always @(*) begin
        if (read2) begin
            out2 = 16'b0;
        end
        else begin
            out2 = 16'bz;
        end
    end
endmodule


module counter(
    input wire [15:0] a,
    input wire jmp,
    input wire rst,
    input wire clk,
    input wire EN,

    output reg [15:0] addr,
    input wire read1,
    input wire read2,
    output reg [15:0] out1,
    output reg [15:0] out2
);

    // Sequential logic for the counter
    always @(posedge clk) begin
        if (rst) begin
            addr <= 16'b0;
        end
        else if (jmp) begin
            addr <= a;
        end
        else if (EN) begin
            addr <= addr + 1;
        end
    end

    // Combinational logic for read1 output (tri-state)
    always @(*) begin
        if (read1) begin
            out1 = addr;
        end
        else begin
            out1 = 16'bz;
        end
    end

    // Combinational logic for read2 output (tri-state)
    always @(*) begin
        if (read2) begin
            out2 = addr;
        end
        else begin
            out2 = 16'bz;
        end
    end

endmodule

module DEC4B(
    input wire [3:0] in,
    input wire EN,
    output wire [15:0] out
    );
    assign out = EN ? (16'b1 << in) : 8'b0;
endmodule

module DEC3B(
    input wire [2:0] in,
    input wire EN,
    output wire [7:0] out
    );
    assign out = EN ? (8'b1 << in) : 8'b0;
endmodule
