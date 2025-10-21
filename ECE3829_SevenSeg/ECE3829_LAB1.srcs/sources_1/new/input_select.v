`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/18/2025 06:48:14 PM
// Design Name: 
// Module Name: input_select
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: calculates the data to display for each of the four displays
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module input_select(
    // mode select switch inputs
    input [1:0] sw,
    
    // 14-bit value input
    input [13:0] swValue,
    
    // Four, seven-segment displays
    output reg [3:0] dispA,
    output reg [3:0] dispB, 
    output reg [3:0] dispC,
    output reg [3:0] dispD
    );
    
    // Sum register to calculate mode 3
    reg [4:0] sum;
    
    always @ (sw)
        case(sw)
            // Display last 4 digits of WPI ID: 0196
            2'b00: begin
                dispA = 4'h0001; 
                dispB = 4'h0005;
                dispC = 4'h0000;
                dispD = 4'h0005;
           end
           
           // Values of the swValue switches in hexadecimal
           2'b01: begin
                dispA = swValue[13:12]; 
                dispB = swValue[11:8];
                dispC = swValue[7:4];
                dispD = swValue[3:0];
           end
           
           // Shows value for display A and B, double the value between A and B for
           // displays C and D
           2'b10: begin
                dispA = swValue[13:12]; 
                dispB = swValue[11:8];
                {dispC, dispD} = swValue[13:8] << 1;
           end
           
           // Shows value for display A and B, add the values of A and B for
           // displays C and D
           2'b11: begin
                sum = swValue[7:4] + swValue[3:0];
                
                dispA = swValue[7:4]; 
                dispB = swValue[3:0];
                dispC = sum[4];
                dispD = sum[3:0];
           end
        endcase
endmodule
