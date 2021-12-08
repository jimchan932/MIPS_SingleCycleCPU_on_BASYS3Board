`timescale 1ns / 1ps

module Clock_FSM(
    input clk,
    input btn,
    output wire clk_en
    
    );
    reg state_reg, state_next;
    
    localparam s0 = 0, s1 = 1;
    initial 
    begin
        state_reg = s0;
    end
    always @(posedge clk)
    begin
        state_reg <= state_next;
    end
    always @* 
    begin
    case(state_reg)
        s0:
        begin
             if(btn)        
                 state_next = s1;
             else
                 state_next = s0;
        end
        s1:
                state_next = s0;
    // there are only two states so no need the 'default' case 
    endcase
    end
    assign clk_en = (state_reg == s0) ? 0 : 1;    
endmodule
