`timescale 1ns / 1ps
module multiplexer32Bit(D0, D1, S, Y);
    input wire [31:0] D0, D1;
    input wire S;
    output reg [31:0] Y;
    
    always @(D0 or D1 or S)
    begin
    if(S)
        Y = D1;
    else
        Y = D0;    
    end
endmodule
