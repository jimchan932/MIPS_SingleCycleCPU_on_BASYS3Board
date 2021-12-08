`timescale 1ns / 1ps

module ALU_Control(
    input wire [2:0] control,
    input wire [5:0] funct,
    output reg [3:0] alu_control
    );
    always @*
    begin
        case(control)
            3'b000:   // load and store operation and addi
                begin
                    alu_control  = 4'b0010;
                end
            3'b100: // set-on-less-than immediate zzz
                begin
                    alu_control = 4'b0111;
                end
            3'b001:  // beq and bne
                begin
                    alu_control = 4'b0110;
                end
            3'b010: // R type
                begin
                    case(funct)
                        6'b100000:
                            alu_control = 4'b0010;    // add
                        6'b100001:                 // addu
                            alu_control = 4'b0010;
                        6'b100010:
                            alu_control = 4'b0110;   // subtract 
                        6'b100100:
                            alu_control = 4'b0000;   // AND
                        6'b100101:
                            alu_control = 4'b0001;   // OR
                        6'b101010:
                            alu_control = 4'b0111;   // set-on-less-than      
                        6'b101011:
                            alu_control = 4'b0111;   // set-on-less-than unsigned      
                        6'b000000:
                            alu_control = 4'b1111; // shift left logical                                                                                                                                  
                    endcase
                end                 
        endcase
    end    
endmodule
