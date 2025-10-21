`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/08/2025 02:29:44 PM
// Design Name: 
// Module Name: vga_blueStripe
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Generates a blue stripe at the bottom of the VGA screen.
// 
// Dependencies: None
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module vga_blueStripe (
    input wire clk,                              // Define 25MHz Clock input               
    input wire reset_n,                          // Define low active reset input          
    input wire [11:0] hcount, vcount,            // Define hcount and vcount for VGA pixels
    input wire blank,                            // Define blank for VGA display           
    output reg [3:0] red,                        // Define red output for VGA display             
    output reg [3:0] green,                      // Define green output for VGA display           
    output reg [3:0] blue                        // Define blue output for VGA display            
    );

    // **Define 12-bit color values**
    parameter BLUE  = 12'b0000_0000_1111,        // Define color parameter for blue  
              BLACK = 12'b0000_0000_0000;        // Define color parameter for black  

    reg [11:0] pixel_color;                      // Define register to store the current pixel color

    // **Determine pixel color based on vertical position**
    always @(*) begin
        if (vcount >= 448)                       // Check if the vertical count is within the bottom region
            pixel_color = BLUE;                  // Assign blue color if in the stripe region
        else
            pixel_color = BLACK;                 // Assign black color elsewhere
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
