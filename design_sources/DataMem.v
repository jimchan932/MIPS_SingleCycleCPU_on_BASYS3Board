`timescale 1ns / 1ps

module DataMem
    #(parameter B = 32, W = 12)
    (
    input wire clk,
    input wire clock_enable,
    input wire [W-1:0] display_number,
    input wire MemWrite,
    input wire MemRead,    
    input wire [W-1:0] address, 
    input wire [B-1:0] w_data,
    output reg [B-1:0] r_data,
    output reg [B-1:0] display_data                           
    );
    
    reg [B-1:0] data_memory_array [2**W-1:0];
    wire [W-1:0] addressIndex;
    assign addressIndex = {2'b00, address[W-1:2]}; 
    
    initial    
    begin
        $readmemh("Data.txt",data_memory_array);     
    end
    always @(posedge clk)
        if(MemWrite && clock_enable)
        begin
            data_memory_array[addressIndex] <= w_data;        
        end    
    
    always @*
    begin
        if(MemRead)
        begin
            r_data = data_memory_array[addressIndex];
        end    
    end
    always @*
    begin
        display_data = data_memory_array[display_number];
    end


endmodule