`timescale 1ns / 1ps

module RegisterFile
    #(parameter B = 32, W = 5, registerAddress = 5'b11111)
    (
    input wire clk,
    input wire clock_enable,
    input wire RegWrite,
    input wire StoreRA,
    input wire [B-1:0] currentPC,
    input wire [W-1:0] w_addr, r_addr1, r_addr2,
    input wire [B-1:0] w_data,
    output reg [B-1:0] r_data1, r_data2,     
    output reg [31:0] registerAddressVal
    );
    reg [B-1:0] reg_file_array [2**W-1:0];
    
    integer i;
    initial begin
        for(i = 0; i < 2**W; i = i + 1)
            reg_file_array[i] = 0; 
    end
    always @(posedge clk)
    begin
        if(clock_enable)
        begin
            if(RegWrite && w_addr != 5'b00000)
                 reg_file_array[w_addr] <= w_data;
            if(StoreRA)
                 reg_file_array[31] <= currentPC + 4;
        end
    end
    always @*
        begin
            r_data1 = reg_file_array[r_addr1];
            r_data2 = reg_file_array[r_addr2];            
            registerAddressVal = reg_file_array[31];                     
        end     
    //assign test3 = reg_file_array[8];
endmodule