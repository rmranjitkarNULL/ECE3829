`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 02/05/2025 10:41:33 PM
// Design Name:
// Module Name: seg_sel
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//   This module selects and controls the seven-segment display output based 
//   on the currently active anode.
//
// Dependencies: None
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module seg_sel(
    output reg [6:0] seg,             // Defines 7-bit output register for seven-segment display
    input [3:0] an,                    // Defines 4-bit input for anodes selection
    input [7:0] sensor_val             // Define 8 bit sensor value to display the ALS values.
    );                                
                                      
    reg [3:0] digit = 0;              // Defines register for digit values (0-15)
                                      
    // **Digit Selection Based on Active Anode**
    always @(*) begin                 // On any signal change
        case(an)                      // Case selection based on active anode
        4'b1110: digit = sensor_val[7:4];        
        4'b1101: digit = sensor_val[3:0];        
        4'b1011: digit = 4'd0;        // Set middle-left anode to display digit 0
        4'b0111: digit = 4'd5;        // Set leftmost anode to display digit 5
        default: digit = 4'd0;        // Default case: display 0
        endcase                       
    end                               
                                      
    // **Seven-Segment Encoding Logic**
    always @(*) begin                 // On any signal change
        case(digit)                   // Case selection for 7-segment encoding
        4'd0: seg = 7'b1000000;       // Display 0
        4'd1: seg = 7'b1111001;       // Display 1
        4'd2: seg = 7'b0100100;       // Display 2
        4'd3: seg = 7'b0110000;       // Display 3
        4'd4: seg = 7'b0011001;       // Display 4
        4'd5: seg = 7'b0010010;       // Display 5
        4'd6: seg = 7'b0000010;       // Display 6
        4'd7: seg = 7'b1111000;       // Display 7
        4'd8: seg = 7'b0000000;       // Display 8
        4'd9: seg = 7'b0010000;       // Display 9
        4'd10: seg = 7'b0001000;      // Display A
        4'd11: seg = 7'b0000011;      // Display B
        4'd12: seg = 7'b1000110;      // Display C
        4'd13: seg = 7'b0100001;      // Display D
        4'd14: seg = 7'b0000110;      // Display E
        4'd15: seg = 7'b0001110;      // Display F
        default: seg = 7'b1111111;    // Default case: Turn off all segments
        endcase
    end
endmodule
