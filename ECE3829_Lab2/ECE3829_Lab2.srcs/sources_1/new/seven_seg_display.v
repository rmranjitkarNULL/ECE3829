`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 02/05/2025 10:45:40 PM
// Design Name:
// Module Name: seven_seg_display
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//   This module integrates an anode cycling module and a seven-segment display 
//   selection module to control a 4-digit seven-segment display.
//
// Dependencies:
//   - an_cycle (Anode Cycling Module)
//   - seg_sel (Seven-Segment Display Selection Module)
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module seven_seg_display(
    input clk,                      // Defines input 25MHz clock
    input reset_n,                  // Defines input active low reset signal
    output [3:0] an,                // Defines anodes control signal
    output [6:0] seg                // Defines cathode control signal for seven-segment display
    );                              
                                    
    wire [3:0] an_wire;             // Defines internal wire for anode control
                                    
    // **Instantiate Anode Cycling Module**
    an_cycle an_driver (            // Instantiating anode cycling module
        .clk(clk),                  // Connects 25MHz clock
        .reset_n(reset_n),          // Connects active-low reset
        .an(an_wire)                // Connects anode wire output
     );                             
                                    
    // **Instantiate Seven-Segment Display Selector**
    seg_sel seg_driver (            // Instantiating seven-segment display selection module
        .an(an_wire),               // Connects anode selection
        .seg(seg)                   // Connects segment output
     );                                 
                                    
    assign an = an_wire;            // Assigns internal anode wire to module output
endmodule
