`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/09/2025 05:19:37 PM
// Design Name: 
// Module Name: debounce
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Implements a debounce circuit to filter out unwanted noise from a button input.
// 
// Dependencies: None
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// - Uses a counter to stabilize the button state.
// - The output changes only if the button maintains a stable state for a fixed duration.
//
//////////////////////////////////////////////////////////////////////////////////

module debounce(
    input btn_in,                               // Define button input signal
    output reg btn_out,                         // Define debounced button output signal
    input clk,                                  // Define clock input (assumed to be 25MHz or similar)
    input reset_n                               // Define low-active reset input
    );
   
    parameter MAX_COUNT = 250_000 - 1;          // Define max count value for debounce delay (assumes 10ms debounce time)
    reg [17:0] count_value = 0;                 // Define counter register for debounce timing
    reg btn_state;                              // Define register to hold the stable button state

    // **Debounce process**
    always @(posedge clk) begin
        if(!reset_n) begin                      // Check if reset is active (low)
            count_value <= 1'b0;                // Reset counter to zero
            btn_out <= btn_in;                  // Initialize output with input value
            btn_state <= btn_in;                // Initialize button state with input value
        end else begin                          // If not in reset
            if(btn_in != btn_state) begin       // If button state has changed
                count_value <= 1'b0;            // Reset counter
                btn_state <= btn_in;            // Update button state
            end else if(count_value == MAX_COUNT) begin // If stable for required duration
                count_value <= 17'd0;           // Reset counter
                btn_out <= btn_state;           // Assign stable button state to output
            end else begin                      // Otherwise, keep counting
                count_value <= count_value + 24'd1; // Increment counter
            end 
        end
    end
    
endmodule
