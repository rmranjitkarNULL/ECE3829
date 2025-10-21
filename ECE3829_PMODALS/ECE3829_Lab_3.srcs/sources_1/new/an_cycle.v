`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 02/05/2025 09:19:46 PM
// Design Name:
// Module Name: an_cycle
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//   This module cycles through the four anodes of the seven-segment display 
//   at a controlled rate using a counter.
//
// Dependencies: None
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module an_cycle(
    input clk,                          // Defines input 25MHz clock                 
    input reset_n,                      // Defines input active low reset signal     
    output reg [3:0] an                 // Defines anodes control output                            
    );                                  
                                       
    reg [16:0] cnt;                     // Defines 17-bit counter for anode cycling
                                        
    // **Counter for Anode Cycling**
    always @(posedge clk) begin         // Increment counter on every clock cycle
        if(reset_n == 1'b0) begin       // If reset is active low,
            cnt <= 17'b0;               //     Reset counter to 0
        end else                        // Else,
            cnt <= cnt + 1;             //     Increment counter
    end                             
                                        
    // **Anode Control Logic**
    always @(*) begin                   // Combinational logic for anode selection
        if(reset_n == 1'b0)             // If reset is active low,
            an = 4'b1111;               //     Turn off all anodes
        else case(cnt[15:14])           // Else, select anode based on counter bits
            2'b00: an = 4'b1110;        //     Activate rightmost anode
            2'b01: an = 4'b1101;        //     Activate middle-right anode
            2'b10: an = 4'b1011;        //     Activate middle-left anode
            2'b11: an = 4'b0111;        //     Activate leftmost anode
        endcase
    end
endmodule
