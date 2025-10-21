`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/19/2025 02:42:11 PM
// Design Name: 
// Module Name: seven_seg
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: e determines which display is on and uses a decoder to convert 
// the 4-bit input into the anode and segment controls for the 7-segment display
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module seven_seg(
     // Four, seven-segment displays
    input [3:0] dispA, dispC, dispB, dispD, select,
    
    // Seven-segment display output
    output reg [6:0] seg,
    
    // Output anode
    output reg [3:0] an
    );
    
    // Mux to select the appropriate display input (A, B, C, or D)
    reg [3:0] display_input;
    
    // Select the proper display and select control the anode for each display
    always @(*) begin
        case(select)
            4'b1000: begin
                display_input = dispA;
                an = 4'b0111;
            end
            4'b0100: begin
                display_input = dispB;
                an = 4'b1011;
            end
            4'b0010: begin
                display_input = dispC;
                an = 4'b1101;
            end
            4'b0001: begin
                display_input = dispD;
                an = 4'b1110;
            end
            default: begin
                display_input = 4'b0000;
                an = 4'b1111;
            end
        endcase
     end
    
    
    always @(*) begin
    case(display_input)
        4'h0: seg = 7'b0000001;
        4'h1: seg = 7'b1001111;
        4'h2: seg = 7'b0010010;
        4'h3: seg = 7'b0000110;
        4'h4: seg = 7'b1001100;
        4'h5: seg = 7'b0100100;
        4'h6: seg = 7'b0100000;
        4'h7: seg = 7'b0001111;
        4'h8: seg = 7'b0000000;
        4'h9: seg = 7'b0001100; 
        4'hA: seg = 7'b0001000;
        4'hB: seg = 7'b1100000;
        4'hC: seg = 7'b0110001;
        4'hD: seg = 7'b1000010;
        4'hE: seg = 7'b0110000;
        4'hF: seg = 7'b0111000;
        default: seg = 7'b1111111;
     endcase
  end
endmodule
