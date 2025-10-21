`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/07/2025 10:57:32 PM
// Design Name: 
// Module Name: green_block
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module vga_greenBlock(
    input wire clk,         
    input wire reset_n,     
    input wire [11:0] hcount, vcount,
    input wire blank,
    output reg [3:0] red,   
    output reg [3:0] green, 
    output reg [3:0] blue
);

    // Define 12-bit color values
    parameter GREEN = 12'b0000_1111_0000,  // (Red=0, Green=F, Blue=0)
    BLACK = 12'b0000_0000_0000;  // (Red=0, Green=0, Blue=0)

    reg [11:0] pixel_color; // Holds selected pixel color

    always @(*) begin
        if ((hcount >= 512) && (hcount < 640) && (vcount < 128)) begin
            pixel_color = GREEN;  
        end else begin
            pixel_color = BLACK;  
        end
    end

    // Extract color components and handle blanking
    always @(*) begin
        if (blank) begin
            red   = 4'b0000;  
            green = 4'b0000;
            blue  = 4'b0000;
        end else begin
            red   = pixel_color[11:8];  
            green = pixel_color[7:4];   
            blue  = pixel_color[3:0];   
        end
    end

endmodule
