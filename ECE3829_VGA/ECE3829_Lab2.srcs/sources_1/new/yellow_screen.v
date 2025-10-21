`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/07/2025 09:27:41 PM
// Design Name: 
// Module Name: vga_yellowScreen
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Generates a solid yellow screen for VGA display.
// 
// Dependencies: None
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module vga_yellowScreen(                                  
    input wire clk,                                       // Define 25MHz Clock input
    input wire reset_n,                                   // Define low active reset input
    input wire [11:0] hcount, vcount,                     // Define hcount and vcount for VGA pixels
    input wire blank,                                     // Define blank for VGA display 
    output reg [3:0] red,                                 // Define red output for VGA display
    output reg [3:0] green,                               // Define green output for VGA display
    output reg [3:0] blue                                 // Define blue output for VGA display
    );                                                    //

    // **Define 12-bit color for yellow**
    parameter YELLOW_SCREEN = 12'b1111_1111_0000;         // Define yellow color (full red, full green, no blue)

    // **Assign pixel color based on blanking signal**
    always@(*) begin                                      //
        if(blank) begin                                   // Check if blanking signal is active
            red   = 4'b0000;                              // Set red component to zero (black)
            green = 4'b0000;                              // Set green component to zero (black)
            blue  = 4'b0000;                              // Set blue component to zero (black)
        end else begin                                    // If not blanking, set yellow color
            red   = YELLOW_SCREEN[11:8];                  // Extract and assign red component
            green = YELLOW_SCREEN[7:4];                   // Extract and assign green component
            blue  = YELLOW_SCREEN[3:0];                   // Extract and assign blue component
        end
    end
         
endmodule
