`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/07/2025 09:27:41 PM
// Design Name: 
// Module Name: yellow_screen
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

module vga_movingBlock (
    input wire clk,                                         // Define 25MHz Clock input               
    input wire reset_n,                                     // Define low active reset input          
    input wire [11:0] hcount, vcount,                       // Define hcount and vcount for vga pixels
    input wire blank,                                       // Define blank for vga display 
    input btn,                                              // Define btn input           
    output reg [3:0] red,                                   // Define red for vga display             
    output reg [3:0] green,                                 // Define green for vga display           
    output reg [3:0] blue                                   // Define blue for vga display 
    );
    
    parameter BLUE   = 12'b0000_0000_1111,                  // Define parameter for blue color
     RED    = 12'b1111_0000_0000,                           // Define parameter for red color
     BLACK  = 12'b0000_0000_0000,                           // Define parameter for black color
     BLOCK_WIDTH  = 32,                                     // Define width of the moving block
     BLOCK_HEIGHT = 32,                                     // Define height of the moving block
     SCREEN_WIDTH = 640,                                    // Define width of the VGA screen
     SCREEN_HEIGHT = 480,                                   // Define height of the VGA screen
     START_X = (SCREEN_WIDTH / 2) - (BLOCK_WIDTH / 2),      // Define the starting x-coordinate of the block
     MAX_COUNT = 12_500_000 - 1;                            // Define max count for a 2Hz enable signal
    
    reg [23:0] count_value = 0;                             // Define register to hold counter value
    reg [3:0] move_counter = 0;                             // Define register to keep track of block movements
    reg [8:0] block_y = 0;                                  // Define register to store y-coordinate of the block
    wire move_enable;                                       // Define wire to enable movement of the block
   
    assign move_enable = (count_value == MAX_COUNT);        // Assign move_enable signal when count reaches MAX_COUNT
    
    // **Counter for move enable signal (2Hz frequency)**
    always @(posedge clk) begin
        if(reset_n == 1'b1) begin                           // If reset is active (high)
            count_value <= 1'b0;                            // Reset counter value to 0
        end else 
        if(count_value == MAX_COUNT) begin                 // If counter reaches MAX_COUNT
            count_value <= 24'd0;                           // Reset counter to 0
        end
        else begin
            count_value <= count_value + 24'd1;            // Increment counter value
        end 
    end   

    // **Block movement logic when button is pressed**
    always @(posedge clk) begin
        if (reset_n) begin                                  // If reset is active (high)
            block_y <= 0;                                   // Reset block y-coordinate to 0
            move_counter <= 0;                              // Reset move counter to 0
        end else 
        if (btn && move_enable) begin                      // If button is pressed and move is enabled
            if (move_counter < 14) begin                   // If move counter is less than 14
                move_counter <= move_counter + 1;          // Increment move counter
                block_y <= block_y + BLOCK_HEIGHT;         // Move block downward by BLOCK_HEIGHT
            end else begin
                move_counter <= 0;                         // Reset move counter
                block_y <= 0;                              // Reset block y-coordinate to top
            end
        end
    end

    reg [11:0] pixel_color = 0;                            // Define register for storing pixel color
    
    // **Determine the pixel color based on block position**
    always @(*) begin
        if (btn) begin                                     // If button is pressed
            if ((hcount >= START_X) && (hcount < (START_X + BLOCK_WIDTH)) &&        // If within block's x range
                (vcount >= block_y) && (vcount < (block_y + BLOCK_HEIGHT))) begin   // If within block's y range
                pixel_color = RED;                         // Assign red color to block
            end else begin
                pixel_color = BLUE;                        // Assign blue color to background
            end
        end else begin
            pixel_color = BLACK;                           // Assign black color when button is not pressed
        end
    end

    // **Output RGB Values with Blanking**
    always @(*) begin
        if (blank) begin
            red   = 4'b0000;                               // Set red to 0 when blanking is active
            green = 4'b0000;                               // Set green to 0 when blanking is active
            blue  = 4'b0000;                               // Set blue to 0 when blanking is active
        end else begin
            red   = pixel_color[11:8];                     // Assign red component from pixel_color
            green = pixel_color[7:4];                      // Assign green component from pixel_color
            blue  = pixel_color[3:0];                      // Assign blue component from pixel_color
        end
    end

endmodule
