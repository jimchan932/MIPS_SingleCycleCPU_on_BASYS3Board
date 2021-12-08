`timescale 1ns / 1ps

module InsMem(input wire[31:0] pc, output wire[31:0] ins);
    reg[31:0] mem[255:0];    
    initial begin
        $readmemh("Instructions.txt",mem);
    end
    assign ins = mem[pc>>2]; 
endmodule