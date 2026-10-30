

module ALU16(
    input wire [15:0] a,
    input wire [15:0] b,
    input wire Cin,

    input wire [3:0] S,
    input wire EN,

    output reg [15:0] out,
    output reg Cout
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
                {Cout, out} = a+b+Cin ;
            end
        end
        else begin
            out = 16'bz;
            Cout = 1'bz;
        end
    end
endmodule

module MUX16_2t1(
    input wire [15:0] a,
    input wire [15:0] b,
    input wire S,

    output reg [15:0] out
    );

    always @(*) begin
        if (S) begin
            out = a;
        end
        else begin
            out = b;
        end
    end
endmodule
