`timescale 1ns / 1ps
module CPU(
    input clk,
    input left_button_display_data,
    input center_button_enable_sort,
    //output wire [7:0] write_data,
    output wire [7:0] instruction_counter, 
    output wire finished_sort,
    output wire clk_en, 
    output wire [6:0] DisplaySegment,
    output wire [3:0] DisplayAnode
);    

    wire[31:0] PC;
    wire[31:0] Instruction; // [31:26], [25:21], [15:11], [15:0]
    // 一开始， PC值位零
    // determine whether to enable clock
    wire clock_enable;
    // Control Signals ...
    wire Control_RegDst;
    wire Control_Branch;
    wire Control_BranchNE;
    wire Control_MemRead;
    wire Control_MemToReg;
    wire [2:0] Control_ALUOp;
    wire Control_MemWrite;
    wire Control_ALUSrc;
    wire Control_RegWrite;
    wire Control_Jump;
    wire Control_StoreRA;
    wire Control_JumpRA;
    wire Control_ZeroFlag;
    
    // Register File Stuff ... 
    wire [4:0] ReadRegisterAddress1;
    wire [4:0] ReadRegisterAddress2;
    wire [4:0] WriteRegisterAddress;
    wire [31:0] WriteRegisterData;
    wire [31:0] ReadRegisterData1;
    wire [31:0] ReadRegisterData2;    
    wire [31:0] RegisterAddressValue;
    // Data Memory stuff ... 
    wire [11:0] MemoryAddress;
    wire [31:0] WriteMemoryData;
    wire [31:0] ReadMemoryData;
        
    wire [31:0] DisplayData;
    reg [11:0] DisplayAddress;
    
    // ALU Stuff
    wire [3:0] Control_ALU;
    wire [31:0] SignExtendedAddress;    
    wire [31:0] ALUInput1;
    wire [31:0] ALUInput2;
    wire [4:0] ALUShiftAmount;
    wire [5:0] ALUFunctionCode;
    wire [31:0] ALUResult;
    
    // 7-segment display
    assign finished_sort = PC[7:0] == 8'b01000000 ? 1 : 0;
    assign clk_en = clock_enable;
    //assign write_data = WriteRegisterData[7:0];
    assign instruction_counter = PC[7:0];
   // assign write_data = WriteRegisterData[7:0];    
    //assign disp_tens = DisplayTens;
    //assign disp_ones = DisplayOnes;
   //  assign q[15:8] = WriteRegisterData[7:0];
    // need to add control unit, register file, ALU, data memory etc.
    assign SignExtendedAddress[15:0] = Instruction[15:0];
    assign SignExtendedAddress[31:16] = Instruction[15] == 1'b1 ? 16'b1111111111111111 : 
                                                                  16'b0000000000000000;
     // need to depend on control signal   
    ProgramCounter uPC(clk, clock_enable,
                       Control_ZeroFlag, Control_Branch, Control_BranchNE, 
                       SignExtendedAddress,
                       Control_Jump, Instruction[25:0],
                       Control_JumpRA,
                       RegisterAddressValue, PC);
    InsMem uInsMem(PC,Instruction); 
    ControlUnit uControlUnit(Instruction[31:26], 
                             Instruction[5:0], // function code 
                             Control_RegDst,
                             Control_Branch,
                             Control_BranchNE,
                             Control_MemRead,
                             Control_MemToReg,
                             Control_ALUOp,
                             Control_MemWrite,
                             Control_ALUSrc,
                             Control_RegWrite,
                             Control_Jump,
                             Control_StoreRA,
                             Control_JumpRA);      
    
    assign ReadRegisterAddress1 = Instruction[25:21];
    assign ReadRegisterAddress2 = Instruction[20:16];
    multiplexer5Bit Multiplexer1(Instruction[20:16], Instruction[15:11], 
                             Control_RegDst, WriteRegisterAddress);    
    RegisterFile uRegFile(clk, clock_enable, Control_RegWrite, Control_StoreRA, PC, WriteRegisterAddress, 
                         ReadRegisterAddress1, ReadRegisterAddress2,
                         WriteRegisterData, ReadRegisterData1, ReadRegisterData2,
                         RegisterAddressValue);                         
    // need to assign WriteRegisterData from data memory etc.
    
    assign ALUInput1 = ReadRegisterData1;
    multiplexer32Bit Multiplexer2(ReadRegisterData2, SignExtendedAddress,
                             Control_ALUSrc, ALUInput2);
    assign ALUShiftAmount = Instruction[10:6];
    assign ALUFunctionCode = Instruction[5:0];  
    ALU_Control ALU_Ctrl(Control_ALUOp, ALUFunctionCode, Control_ALU);
    arith_logic_unit uALU(ALUInput1, ALUInput2, ALUShiftAmount, 
                          Control_ALU,
                          Control_ZeroFlag, ALUResult);                      

  assign WriteMemoryData = ReadRegisterData2;
  assign MemoryAddress = ALUResult[11:0];  
  
  always @(posedge left_button_display_data)
  begin
    DisplayAddress = (DisplayAddress + 1) % 8;
  end
  // 我们在这使用10位地址，因为我们所用的地址不用32位那么多   
  DataMem uDataMemory(clk, clock_enable,
        DisplayAddress, 
        Control_MemWrite, Control_MemRead,
        MemoryAddress, WriteMemoryData, ReadMemoryData, DisplayData
        );  
    
  multiplexer32Bit Multiplexer3(ALUResult, ReadMemoryData, Control_MemToReg, WriteRegisterData);      

  sevenseg_driver Driver(clk, 
    DisplayAddress[3:0], (DisplayData / 100), ((DisplayData % 100) / 10),((DisplayData % 100) % 10),                  
    DisplaySegment, DisplayAnode);  
    
  Clock_FSM finite_state_machine(clk, center_button_enable_sort, clock_enable);
endmodule