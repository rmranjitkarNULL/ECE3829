`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: WPI ECE3829
// Engineer: 
// 
// Create Date: 01/18/2025 02:55:04 PM
// Design Name: Ryan Ranjitkar
// Module Name: decoder
// Project Name: Decoder Tutorial
// Target Devices: Basys3 Developement Board
// Tool Versions: 2024.2
// Description: 
// 3 to 8 decoder. Takes 3 inputs and lights a single LED corresponding to the value in binary
// Dependencies: 
// NA
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module decoder(
    input [2:0] sw, //switch inputs
    output reg [7:0] LED //LED outputs, reg type required because in always block
    );
    
    // Decoder maps three switch inputs to seven LED outputs
    //lighting one output at a time corresponding to the switch setting
    always @ (sw)
        case (sw)
            3'b000: LED = 8'b00000001;
            3'b001: LED = 8'b00000010;
            3'b010: LED = 8'b00000100;
            3'b011: LED = 8'b00001000;
            3'b100: LED = 8'b00010000;
            3'b101: LED = 8'b00100000;
            3'b110: LED = 8'b01000000;
            3'b111: LED = 8'b10000000;
            default: LED = 8'b00000000;
        endcase         
endmodule
