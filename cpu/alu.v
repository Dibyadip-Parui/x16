

module ALU16(
    input wire [15:0] a,
    input wire [15:0] b,
    input wire Cin,
    input wire clk,

    input wire [3:0] S,
    input wire EN,

    output reg [15:0] out,
    output reg Cout,

    output reg eq,
    output reg ab,
    output reg be
    );

    always @(*) begin
        if (EN) begin
            if (S==4'b0000) begin
                {Cout, out} = a+b;
            end 
            else if (S==1) begin
                out = a-b;
            end else if (S==4'b0010) begin
                out = a^b;
            end else if (S==4'b0011) begin
                out = a|b;
            end else if (S==4'b0100) begin
                out = a&b;
            end else if (S==4'b0101) begin
                out = a~&b;
            end else if (S==4'b0110) begin
                {Cout, out} = a+b+Cin;
            end else if (S==4'b0111) begin
                if (a==b) begin
                    eq = 1;
                    ab = 0;
                    be = 0;
                end
                else if (a>b) begin
                    eq = 0;
                    ab = 1;
                    be = 0;
                end 
                else begin
                    eq = 0;
                    ab = 0;
                    be = 1;
                end
            end
        end
        else begin
            out = 16'bz;
            Cout = 1'bz;
        end
    end
endmodule

module MUX16_2t1(
    input wire [15:0] out1,
    input wire [15:0] out2,
    input wire [15:0] data,
    input wire IN_S,

    output reg [15:0] aluIn1,
    output reg [15:0] aluIn2
    );

    always @(*) begin
        if (~IN_S) begin
            aluIn1 = out1;
            aluIn2 = out2;
        end
        else begin
            aluIn1 = out2;
            aluIn2 = data;
        end
    end
endmodule
