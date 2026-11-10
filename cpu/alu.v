

module ALU16(
    input wire [15:0] a,
    input wire [15:0] b,

    input wire [3:0] S,
    input wire EN,

    output reg [15:0] out,
    output reg Cout,

    output reg eq,
    output reg ca,
    output reg cb
    );

    always @(*) begin
        if (EN) begin
            if (S==4'b0000) begin
                {Cout, out} = a+b;
            end 
            else if (S==1) begin
                out = a-b;
                if (a==b) begin
                    eq=1;
                    ca=0;
                    cb=0;
                end
                else if (a>b) begin
                    eq=0;
                    ca=1;
                    cb=0;
                end
                else if (a<b) begin
                    eq=0;
                    ca=0;
                    cb=1;
                end
                else begin
                    eq = 0;
                    ca = 0;
                    cb = 0;
                end
            end else if (S==4'b0010) begin
                out = a^b;
            end else if (S==4'b0011) begin
                out = a|b;
            end else if (S==4'b0100) begin
                out = a&b;
            end else if (S==4'b0101) begin
                out = a~&b;
            end else if (S==4'b0110) begin
                {Cout, out} = a+b+Cout;
            end else if (S==4'b0111) begin
                out = a >> b;
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
