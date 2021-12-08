`timescale 1ns / 1ps

module ProgramCounter(
    input wire clk,
    input wire clock_enable,
    input wire zeroFlag,
    input wire branchFlag,
    input wire branchNEFlag, 
    input wire [31:0] branchAddress,
    input wire jumpFlag,    
    input wire [25:0] jumpAddress, 
    input wire jumpRAFlag, 
    input wire [31:0] RegisterAddressValue,
    output wire [31:0]pc
    );
    reg [31:0] pc_reg, pc_reg_next;
    initial begin
        pc_reg <= 0;
        pc_reg_next <= 0;
    end
    
    always @(posedge clk)
    begin
        if(clock_enable)
        begin    
            pc_reg <= pc_reg_next;        
        end
    end
    
    always @ *
    begin
        pc_reg_next = pc_reg + 4;
        if((branchFlag && zeroFlag) || (branchNEFlag && !zeroFlag)) 
            pc_reg_next = pc_reg_next + (branchAddress << 2);
        else if(jumpFlag)
            pc_reg_next = {pc_reg_next[31:28], jumpAddress, 1'b0, 1'b0};      
        else if(jumpRAFlag)
            pc_reg_next = RegisterAddressValue;
    end      
    assign pc = pc_reg;
endmodule