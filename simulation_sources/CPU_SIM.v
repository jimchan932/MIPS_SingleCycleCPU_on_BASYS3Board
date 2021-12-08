`timescale 1ns / 1ps
module CPU_SIM();
    reg clk;
    reg left_button_display_data;
    reg center_button_enable_sort;    
//    wire [7:0] write_data;
    wire [7:0] instruction_counter;
    wire finished_sort;    
    wire clk_enable;

    wire [6:0] DisplaySeg;
    wire [3:0] DisplayAnode;
    //wire [3:0] disp_tens;
    //wire [3:0] disp_ones;
   /*
module CPU(
    input clk,
    input left_button_display_data,
    input center_button_enable_sort,
    output wire [7:0] write_data,
    output wire [7:0] instruction_counter,
    output wire finished_sort,
    output wire [6:0] DisplaySegment,
    output wire [3:0] DisplayLED    
);       
   */ 
    
    CPU CPU_SIMULATION(clk,
    left_button_display_data,
    center_button_enable_sort,
    //write_data,
    instruction_counter,
    finished_sort,    
    clk_enable,    

    DisplaySeg,
    DisplayAnode);
    //disp_tens, disp_ones);
    initial 
    begin
     clk = 0; 
     center_button_enable_sort = 1;   
     left_button_display_data = 0;     
    end
    always 
    begin 
    #10 clk = ~clk;
    #10 left_button_display_data = ~left_button_display_data;
    end
endmodule
