`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 
// Design Name: 
// Module Name: vga_sel
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
//   This module selects different VGA display modes based on switch input and 
//   button press. It interfaces with multiple VGA modules and controls the 
//   display accordingly.
// 
// Dependencies: 
//   - vga_controller_640_60
//   - vga_yellowScreen
//   - vga_redWhiteBars
//   - vga_greenBlock
//   - vga_blueStripe
//   - vga_movingBlock
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module vga_sel (
    input wire clk,           // Define 50 MHz system clock
    input wire reset_n,       // Define active-low reset input
    input wire [1:0] sw,      // Define 2-bit switch input to select mode
    input wire btn,           // Define button input for moving block
    output wire HS,           // Define horizontal sync for VGA
    output wire VS,           // Define vertical sync for VGA
    output reg [3:0] red,     // Define red output for VGA display
    output reg [3:0] green,   // Define green output for VGA display
    output reg [3:0] blue     // Define blue output for VGA display
);

    // **Define color output wires for different modules**
    wire [3:0] red_yellow, red_bars, red_block, red_blue, red_moving;      
    wire [3:0] green_yellow, green_bars, green_block, green_blue, green_moving;  
    wire [3:0] blue_yellow, blue_bars, blue_block, blue_blue, blue_moving;       

    wire blank;                // Define wire for blank signal
    wire [10:0] hcount, vcount; // Define wires for horizontal and vertical pixel positions

    // **Instantiate VGA Controller Module**
    vga_controller_640_60 vga_ctrl (
        .rst(reset_n),         // Connect reset signal
        .pixel_clk(clk),       // Connect clock signal
        .HS(HS),               // Connect horizontal sync output
        .VS(VS),               // Connect vertical sync output
        .hcount(hcount),       // Connect horizontal count output
        .vcount(vcount),       // Connect vertical count output
        .blank(blank)          // Connect blanking signal output
    );

    // **Instantiate Yellow Screen Module**
    vga_yellowScreen yellow_inst (
        .clk(clk), 
        .reset_n(reset_n),
        .hcount(hcount),
        .vcount(vcount),
        .blank(blank),
        .red(red_yellow),
        .green(green_yellow), 
        .blue(blue_yellow)
    );

    // **Instantiate Red/White Bars Module**
    vga_redWhiteBars bars_inst (
        .clk(clk), 
        .reset_n(reset_n),
        .hcount(hcount),
        .vcount(vcount),
        .blank(blank),
        .red(red_bars), 
        .green(green_bars), 
        .blue(blue_bars)
    );

    // **Instantiate Green Block Module**
    vga_greenBlock green_inst (
        .clk(clk), 
        .reset_n(reset_n),
        .hcount(hcount),
        .vcount(vcount),
        .blank(blank),
        .red(red_block), 
        .green(green_block), 
        .blue(blue_block)
    );

    // **Instantiate Blue Stripe Module**
    vga_blueStripe blue_inst (
        .clk(clk), 
        .reset_n(reset_n),
        .hcount(hcount),
        .vcount(vcount),
        .blank(blank),
        .red(red_blue), 
        .green(green_blue), 
        .blue(blue_blue)
    );

    // **Instantiate Moving Block Module**
    vga_movingBlock moving_inst (
        .clk(clk), 
        .reset_n(reset_n), 
        .btn(btn),             // Connect button input
        .hcount(hcount),
        .vcount(vcount),
        .blank(blank),
        .red(red_moving), 
        .green(green_moving), 
        .blue(blue_moving)
    );
    
    // **Mode Selection Based on Switch Input**
    always @(*) begin
        if (btn) begin          // If button is pressed, display moving block mode
            red = red_moving;
            green = green_moving;
            blue = blue_moving;
        end else begin
            case (sw)
                2'b00: begin    // Mode 00: Yellow Screen
                    red = red_yellow;
                    green = green_yellow;
                    blue = blue_yellow;
                end
                2'b01: begin    // Mode 01: Red/White Bars
                    red = red_bars;
                    green = green_bars;
                    blue = blue_bars;
                end
                2'b10: begin    // Mode 10: Green Block
                    red = red_block;
                    green = green_block;
                    blue = blue_block;
                end
                2'b11: begin    // Mode 11: Blue Stripe
                    red = red_blue;
                    green = green_blue;
                    blue = blue_blue;
                end
                default: begin  // Default case: Black screen
                    red = 4'b0000;
                    green = 4'b0000;
                    blue = 4'b0000;
                end
            endcase
        end
    end

endmodule
