`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/07/2025 10:34:45 PM
// Design Name: 
// Module Name: vga_redWhiteBars
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Generates alternating red and white vertical bars for VGA display.
// 
// Dependencies: None
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module vga_redWhiteBars(
    input wire clk,                              // Define 25MHz Clock input            
    input wire reset_n,                          // Define low active reset input       
    input wire [11:0] hcount, vcount,            // Define hcount and vcount for VGA pixels
    input wire blank,                            // Define blank for VGA display           
    output reg [3:0] red,                        // Define red output for VGA display             
    output reg [3:0] green,                      // Define green output for VGA display           
    output reg [3:0] blue                        // Define blue output for VGA display            
    );

    // **Define 12-bit color values**
    parameter RED   = 12'b1111_0000_0000,        // Define color parameter for red  
              WHITE = 12'b1111_1111_1111;        // Define color parameter for white  

    reg [11:0] pixel_color;                      // Define register to hold selected pixel color

    // **Determine pixel color based on horizontal position**
    always @(*) begin
        pixel_color = (hcount[4] == 1'b0) ? RED : WHITE; // Alternate colors based on the 5th bit of hcount
    end

    // **Output RGB values while handling blanking**
    always @(*) begin
        if (blank) begin                         // Check if the display is blanked
            red   = 4'b0000;                     // Set red component to zero
            green = 4'b0000;                     // Set green component to zero
            blue  = 4'b0000;                     // Set blue component to zero
        end else begin
            red   = pixel_color[11:8];           // Extract and assign red component
            green = pixel_color[7:4];            // Extract and assign green component
            blue  = pixel_color[3:0];            // Extract and assign blue component
        end
    end

endmodule
