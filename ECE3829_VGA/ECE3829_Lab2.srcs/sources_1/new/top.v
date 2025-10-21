`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/07/2025 09:39:39 PM
// Design Name: 
// Module Name: top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
//   Top-level module integrating VGA display, debouncing, clock generation, 
//   and seven-segment display.
// 
// Dependencies: 
//   - clk_mmcm (Clock Generator)
//   - debounce (Debouncing Module)
//   - seven_seg_display (Seven Segment Display Controller)
//   - vga_sel (VGA Controller with Mode Selection)
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module top(
    input clk,                   // Define input system clock (assumed 50 MHz)
    input btnC,                  // Define center button input (used for reset)
    input btnR,                  // Define right button input (used for VGA mode change)
    input [1:0] sw,              // Define 2-bit switch input for VGA mode selection
    output [6:0] seg,            // Define 7-segment display output
    output [3:0] an,             // Define 4-bit anode control for 7-segment display
    output wire [3:0] vgaRed,    // Define VGA red color output
    output wire [3:0] vgaBlue,   // Define VGA blue color output
    output wire [3:0] vgaGreen,  // Define VGA green color output
    output Hsync,                // Define VGA horizontal sync output
    output Vsync                 // Define VGA vertical sync output
);
    
    wire reset_n;                 // Define wire for active-low reset signal
    wire clk_25MHz;               // Define wire for 25 MHz clock signal
    wire db_btn;                  // Define wire for debounced button signal
    wire db_sw0;                  // Define wire for debounced switch 0 signal
    wire db_sw1;                  // Define wire for debounced switch 1 signal
    
    // **Instantiate Clock Generator (25MHz)**
    clk_mmcm clk_out
    (
        .clk_25MHz(clk_25MHz),   // Generate 25MHz clock output
        .reset(btnC),            // Reset signal from center button
        .locked(reset_n),        // Locked signal (active-low reset)
        .clk_in1(clk)            // Input clock (system clock)
    );
    
    // **Instantiate Debounce Module for Button (btnR)**
    debounce debounce_inst_btnR
    (
        .btn_in(btnR),           // Input raw button signal
        .btn_out(db_btnR),        // Output debounced button signal
        .clk(clk_25MHz),         // 25 MHz clock input
        .reset_n(reset_n)        // Reset signal
    );
    
    // **Instantiate Debounce Module for Switch 0**
    debounce debounce_inst_sw0
    (
        .btn_in(sw[0]),          // Input raw switch signal (sw[0])
        .btn_out(db_sw0),        // Output debounced switch signal
        .clk(clk_25MHz),         // 25 MHz clock input
        .reset_n(reset_n)        // Reset signal
    );
    
    // **Instantiate Debounce Module for Switch 1**
    debounce debounce_inst_sw1
    (
        .btn_in(sw[1]),          // Input raw switch signal (sw[1])
        .btn_out(db_sw1),        // Output debounced switch signal
        .clk(clk_25MHz),         // 25 MHz clock input
        .reset_n(reset_n)        // Reset signal
    );
    
    // **Instantiate Seven-Segment Display Controller**
    seven_seg_display seg_inst
    (
        .clk(clk_25MHz),         // 25 MHz clock input
        .reset_n(reset_n),       // Reset signal
        .an(an),                 // Output anode signals for seven-segment display
        .seg(seg)                // Output segment control signals
    );
    
    // **Instantiate VGA Mode Selection Module**
    vga_sel vga_control
    (
        .clk(clk_25MHz),         // 25 MHz clock input
        .reset_n(~reset_n),      // Active-high reset for VGA module
        .HS(Hsync),              // Output horizontal sync signal
        .VS(Vsync),              // Output vertical sync signal
        .red(vgaRed),            // Output VGA red component
        .green(vgaGreen),        // Output VGA green component
        .blue(vgaBlue),          // Output VGA blue component
        .btn(btnR),              // Button input for moving block mode
        .sw(sw)                  // Switch input for mode selection
    );

endmodule
