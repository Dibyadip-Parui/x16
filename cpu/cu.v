`include "/mnt/home/User/Projects/x16/V2x16/cpu/reg.v"

module CU(
    input wire [15:0] ins,
    input wire clk,
    input wire rst,

    output wire [15:0] data,

    output wire [3:0] WR,
    output wire WR_EN,
    output wire [3:0] ALU1,
    output wire ALU1_EN,
    output wire [3:0] ALU2,
    output wire ALU2_EN,

    output wire [3:0] ALU,
    output wire ALU_EN,
    output wire IN_S,
    output wire count
    );

    wire [15:0] SVins; //This wire contains the saved instruction
    wire [15:0] MainOp; //this wire is the decoded main opcode
    wire fetch, extraCLK, execute; //these wires hold the state of cpu
    wire [2:0] SubOp; //this wire has the sub opcode
    wire InsLength; //this wire has the instruction length

    //Initializing the wires
    assign InsLength = SVins[15];
    assign SubOp = SVins[14:12];

    InsT int1 (.clk(~clk), .rst(rst), .f(fetch), .ex(extraCLK), .e(execute));
    Reg16$ ir (.in(ins), .sv(fetch), .clk(~clk), .rst(rst), .read(execute), .out(SVins));

    DEC4B InsDec (.in(SVins[11:8]), .EN(execute), .out(MainOp));

    //Assigning the ALU IO
    assign ALU = SubOp;
    assign ALU_EN = MainOp[1] | MainOp[2];

    assign ALU1 = SVins[7:4];
    assign ALU1_EN = MainOp[1];

    assign ALU2 = SVins[3:0];
    assign ALU2_EN = MainOp[1] | MainOp[2];

    assign WR = SVins[7:4];
    assign WR_EN = MainOp[1] | MainOp[2];

    //assigning the count wire
    assign count = fetch | (extraCLK & InsLength);

    //assigning the IN_S wire whic selects between data bus and output2 for ALU Input 2
    assign IN_S = MainOp[2];

    //assigning the data bus
    EN16 en1 (.a(ins), .en(MainOp[2]), .out(data));

endmodule

module InsT(
    input wire clk,
    input wire rst,
    output reg f,
    output reg ex,
    output reg e
    );

    always @(posedge clk) begin
        if (f) begin
            f = 1'b0;
            ex = 1'b1;
            e = 1'b0;
        end
        else if (ex) begin
            f = 1'b0;
            ex = 1'b0;
            e = 1'b1;
        end
        else if (e) begin
            f = 1'b1;
            ex = 1'b0;
            e = 1'b0;
        end
    end

    always @(*) begin
        if (rst) begin
            f = 1'b1;
            ex = 1'b0;
            e = 1'b0;
        end
    end
endmodule

module EN16(
    input wire [15:0] a,
    input wire en,
    output reg [15:0] out
    );

    always @(*) begin
        if (en) begin
            out = a;
        end
        else begin
            out = 16'bz;
        end
    end
endmodule
