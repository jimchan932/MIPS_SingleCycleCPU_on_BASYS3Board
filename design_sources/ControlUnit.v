`timescale 1ns / 1ps

module ControlUnit(
    input wire [5:0] instruction,  // 31:26
    input wire [5:0] funct, 
    output reg RegDst,
    output reg Branch,
    output reg BranchNE,    
    output reg MemRead,
    output reg MemToReg,
    output reg [2:0] ALUOp,
    output reg MemWrite,
    output reg ALUSrc,
    output reg RegWrite,
    output reg Jump,
    output reg storeRA,
    output reg jumpRA
    );
    // neeed to consider control lines for add immiediate
    /*
        RegDst
        ALUSrc
        MemToReg
        RegWrite
        MemRead
        MemWrite
        Branch
        ALUOp
    */
    always @* 
        case(instruction)
            6'b000000: // R type     
            begin
            if(funct == 6'b001000) // jump register instruction
            begin
                //RegDst = X;
                //ALUSrc = X;
                //MemToReg = 0;
                RegWrite = 0;
                //MemRead = X;
                MemWrite = 0;
                Branch  = 0;
                BranchNE = 0;
                //ALUOp = 2'b10;
                Jump = 0;
                storeRA = 0;
                jumpRA = 1;
            end                            
            else
            begin
                RegDst = 1;
                ALUSrc = 0;
                MemToReg = 0;
                RegWrite = 1;
                MemRead = 0;
                MemWrite = 0;
                Branch  = 0;
                BranchNE = 0;
                ALUOp = 3'b010;
                Jump = 0;
                storeRA = 0;
                jumpRA = 0;
            end   
            end               
            6'b000100: // beq
            begin
                //RegDst = X;
                ALUSrc = 0;
                //MemToReg = X;
                RegWrite = 0;
                MemRead = 0;
                MemWrite = 0;
                Branch  = 1;
                BranchNE = 0;
                ALUOp = 3'b001;
                Jump = 0;   
                storeRA = 0;
                jumpRA = 0;                             
            end
            6'b000101: // bne
            begin
                //RegDst = X;
                ALUSrc = 0;
                //MemToReg = X;
                RegWrite = 0;
                MemRead = 0;
                MemWrite = 0;
                Branch  = 0;
                BranchNE = 1;
                ALUOp = 3'b001;
                Jump = 0;     
                storeRA = 0;
                jumpRA = 0;                
            end           
            6'b000011: // jal
            begin
                RegDst = 0;
                ALUSrc = 0;
                MemToReg = 0;
                MemRead  = 0;
                //
                MemWrite = 0;
                RegWrite = 0;
                Branch = 0;
                BranchNE = 0;
                //ALUOp = X
                Jump = 1;
                storeRA = 1;     
                jumpRA = 0; 
            end     
            6'b000010: // jump
            begin
            // No need to change  
                RegDst = 0;
                ALUSrc = 0;
                MemToReg = 0;
                MemRead  = 0;
           // No operation                      
                MemWrite = 0;
                RegWrite = 0;
                Branch = 0;
                BranchNE = 0;
                //ALUOp = X
                Jump = 1;
                storeRA = 0;     
                jumpRA = 0; 
            end    
            6'b001010: // set on less than immediate
            begin
                RegDst = 0; // $rt is the destination
                ALUSrc = 1; // immediate constant 
                MemToReg = 0; // we are not from memory, instead we are reading from ALU 
                RegWrite = 1; // we are writing to register
                MemRead = 0;  // we are not reading memory
                MemWrite = 0; // we are not writing memory
                Branch  = 0;  // no need 
                BranchNE = 0; // no need 
                ALUOp = 3'b100; // ALUOps for set on less than immmediate ????
                Jump = 0; // no need 
                storeRA = 0;  // no need 
                jumpRA = 0;    // no need         
            end
            6'b100011: // lw
            begin
                RegDst = 0;
                ALUSrc = 1;
                MemToReg = 1;
                RegWrite = 1;
                MemRead = 1;
                MemWrite = 0;
                Branch  = 0;
                BranchNE = 0;
                ALUOp = 3'b000;
                Jump = 0;
                storeRA = 0;
                jumpRA = 0;
            end
            6'b101011: // sw 
            begin
                RegDst = 0;
                ALUSrc = 1;
                MemToReg = 0;
                RegWrite = 0;
                MemRead = 0;
                MemWrite = 1;
                Branch  = 0;
                BranchNE = 0;
                ALUOp = 3'b000;
                Jump = 0;
                storeRA = 0;
                jumpRA = 0;
            end     
            6'b001000: // add immediate 
            begin
                RegDst = 0; //  $rt is the destination 
                ALUSrc = 1; //  16 bit constant value. 
                MemToReg = 0; // no need to read memory
                RegWrite = 1; // we are writing to register 
                MemRead = 0;  // we are not reading from memory
                MemWrite = 0; // we are not writing into memory
                Branch = 0; // not branch operaiton
                BranchNE = 0;
                ALUOp = 3'b000;
                Jump = 0;
                storeRA = 0;
                jumpRA = 0;
            end                                            
            6'b001001: // add immediate unsigned
            begin
                RegDst = 0;   //  $rt is the destination 
                ALUSrc = 1;   //  16 bit constant value. 
                MemToReg = 0; // not reading from memory, but ALU
                RegWrite = 1; // we are writing to register 
                MemRead = 0;  // we are not reading from memory
                MemWrite = 0; // we are not writing into memory
                Branch = 0;   // not branch operaiton
                BranchNE = 0;
                ALUOp = 3'b000;
                Jump = 0;
                storeRA = 0;
                jumpRA = 0;
            end       
            default:
            begin
                RegDst = 0; 
                ALUSrc = 0;  
                MemToReg = 0;
                RegWrite = 0; 
                MemRead = 0;  
                MemWrite = 0;
                Branch = 0;   
                BranchNE = 0;
                ALUOp = 3'b000;
                Jump = 0;
                storeRA = 0;
                jumpRA = 0;            
            end                 
        endcase
endmodule
