`timescale  1ns / 1ps

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
        else begin
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


module tb;

reg clk;
reg rst;

wire f, ex, e;

InsT inst0 (.clk(clk), .rst(rst), .f(f), .ex(ex), .e(e));

always begin
#5 clk = ~clk;
end

initial begin
    
    rst = 1;
    #5
    rst = 0;
    #5
    clk = 0;
    #20 
    $finish; 
end

initial begin
    $monitor("Time = %t clk = %b e=%b f=%b ex=%b", $time, clk, e, f, ex);
end

endmodule