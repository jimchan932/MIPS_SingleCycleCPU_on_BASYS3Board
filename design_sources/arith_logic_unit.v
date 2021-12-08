`timescale 1ns / 1ps

module arith_logic_unit(
    input wire [31:0] op1, [31:0] op2, 
    input wire [4:0] shamt,
    input wire [3:0] alu_control,
    output reg zeroFlag,
    output reg[31:0] result    
    );
        always @*
        begin
            case(alu_control)
                4'b0010: // add, including operations for lw, sw etc
                begin
                   result = op1 + op2;
                   zeroFlag = 0;
                end
                4'b0110: // subtract
                begin
                   result = op1 - op2;
                   zeroFlag = (op1 - op2) == 0; //(op1 > op2) || (op1 < op2) ? 1 : 0;
                end 
                4'b0000:  // AND
                begin
                    result = op1 & op2;
                    zeroFlag = 0;
                end           
                4'b0001:  // OR
                begin
                    result = op1 | op2;
                    zeroFlag = 0;
                end          
                4'b0111:  // Set on Less Than
                begin
                    result = $signed(op1) < $signed(op2);
                    zeroFlag = 0;
                end  
                4'b1111: // shift left logical
                begin
                    result = op2 << shamt; 
                    zeroFlag = 0;
                end
                default:                    
                    zeroFlag = 0;
            endcase                    
        end
endmodule
