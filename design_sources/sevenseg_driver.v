`timescale 1ns / 1ps
module sevenseg_driver(
    input wire clk,
    input [3:0] in1,
    input [3:0] in2,
    input [3:0] in3,
    input [3:0] in4,
    output reg [6:0] seg,
    output reg [3:0] an    
    );
    localparam LEFT = 2'b00, MIDLEFT = 2'b01, MIDRIGHT = 2'b10, RIGHT = 2'b11; 
    reg [3:0] LED_BCD;
    
    reg [19:0] refresh_counter;  // 20-bit for creting 10.5ms refresh period
 
    // the first 18-bit for creating 2.6ms digit period
    // the other 2-bit for creating 4 LED-activating signals    
    wire [1:0] LED_activating_counter;
    // count        0    ->  1  ->  2  ->  3
    // activates    LED1    LED2   LED3   LED4
    // and repeat   
    always @(posedge clk)
    begin
        refresh_counter <= refresh_counter + 1;
    end
    assign LED_activating_counter = refresh_counter[19:18];
    //always @(posedge segclk[12] or posedge clr)
    always @*
        begin
            case(LED_activating_counter)
            LEFT:
            begin 
                LED_BCD <= in1;
                an <= 4'b0111;
            end
            MIDLEFT:
            begin
                LED_BCD <= in2;
                an <= 4'b1011;     
            end
            MIDRIGHT:
            begin
                LED_BCD <= in3;
                an <= 4'b1101;           
            end
            RIGHT:
            begin
                LED_BCD <= in4;
                an <= 4'b1110;             
            end           
            default:
            begin
                LED_BCD <= in1;
                an <= 4'b0111;
            end             
            endcase
        end            
    always @(*)
    begin
        case(LED_BCD)
        4'b0000: seg = 7'b0000001; // "0"     
        4'b0001: seg = 7'b1001111; // "1" 
        4'b0010: seg = 7'b0010010; // "2" 
        4'b0011: seg = 7'b0000110; // "3" 
        4'b0100: seg  = 7'b1001100; // "4" 
        4'b0101: seg = 7'b0100100; // "5" 
        4'b0110: seg  = 7'b0100000; // "6" 
        4'b0111: seg  = 7'b0001111; // "7" 
        4'b1000: seg  = 7'b0000000; // "8"     
        4'b1001: seg = 7'b0000100; // "9" 
        default: seg  = 7'b0000001; // "0"
        endcase
    end
endmodule
