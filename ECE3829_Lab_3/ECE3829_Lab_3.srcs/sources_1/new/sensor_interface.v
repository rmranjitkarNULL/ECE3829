`timescale 1ns / 1ps  // Defines the simulation time unit and precision

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/21/2025 07:43:24 AM
// Design Name: Sensor Interface
// Module Name: sensor_interface
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
//   Interfaces with a light sensor module, generating a 1 MHz serial clock (sclk),
//   controlling chip select (cs_n), and reading sensor data at a 1Hz sample rate.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module sensor_interface #(parameter sampleRATE = 4) (
    input clk, reset_n,        // 10MHz system clock and active-low reset
    input sdo,                 // Serial data output from sensor
    output reg sclk,           // Serial clock output for sensor communication
    output reg cs_n,           // Chip select signal for sensor
    output reg [7:0] sensor_val // 8-bit processed sensor value for display
);

    // Define timing parameters
    localparam SCLK_NEGEDGE = sampleRATE - 1,         // Negative edge of sclk
               SCLK_POSEDGE = (sampleRATE / 2) - 1,   // Positive edge of sclk
               ONESEC_COUNT = 10000000 - 1;           // Counter max for 1 Hz enable

    // Define state machine states
    localparam S_IDLE = 2'b00,   // Idle: sensor inactive
               S_WAIT = 2'b01,   // Wait: delays for 1 second
               S_READ = 2'b10,   // Read: reads data from sensor
               S_DONE = 2'b11;   // Done: finalize and return to idle

    // Registers and counters
    reg [1:0] count;                        // Counter to generate 2.5MHz clock
    reg [23:0] countOneSec;                 // Counter for 1Hz sample rate
    wire second_en;                          // 1Hz enable signal (formerly oneSecondEn)
    wire risingEdge, fallingEdge;            // Rising and falling edge detection
    reg [14:0] shift_reg;                    // Shift register for incoming data (formerly serialShiftData)
    reg [14:0] serialData;                   // Final captured sensor data
    reg [1:0] current_state, next_state;     // State machine registers
    integer index;                           // Counter for serial data shifts (formerly i)

    // Edge detection for serial clock
    assign risingEdge = (count == SCLK_POSEDGE) ? 1'b1 : 1'b0; 
    assign fallingEdge = (count == SCLK_NEGEDGE) ? 1'b1 : 1'b0; 
    assign second_en = (countOneSec == ONESEC_COUNT) ? 1'b1 : 1'b0; 

    // Finite State Machine for sensor communication
    always @(posedge clk) begin
        if (reset_n == 1'b0) begin
            current_state <= S_IDLE;        // Reset to idle state
            shift_reg <= 15'd0;             // Clear shift register
        end
        
        case (next_state)
            S_IDLE: begin  // Idle state, waiting for 1-second interval
                if (reset_n == 1'b0) 
                    next_state <= S_IDLE;  // Stay idle if reset is active
                else 
                    next_state <= S_WAIT;  // Move to wait state
            end

            S_WAIT: begin  // Wait 1 second before reading data
                if (second_en == 1'b1) begin
                    index <= 0;              // Reset shift index
                    next_state <= S_READ;    // Proceed to read state
                end else 
                    next_state <= S_WAIT;    // Continue waiting
            end

            S_READ: begin  // Read data from sensor
                cs_n <= 1'b0;  // Activate chip select (sensor communication)
                if (index == 16) begin
                    cs_n <= 1'b1;  // Deactivate chip select
                    next_state <= S_DONE;  // Move to done state
                end else if (risingEdge == 1'b1) begin
                    shift_reg <= {shift_reg[13:0], sdo}; // Shift in sensor data
                    index <= index + 1;  // Increment bit index
                    next_state <= S_READ;  // Continue reading
                end
            end

            S_DONE: begin  // Done state: finalize data and return to idle
                next_state <= S_IDLE;  // Transition back to idle
                serialData <= shift_reg;  // Store final data
            end
            
            default: next_state <= S_IDLE;  // Default case: return to idle
        endcase
        
        current_state <= next_state;  // Update state at each clock cycle
    end

    // Counter logic to generate serial clock
    always @(posedge clk) begin
        if (reset_n == 1'b0) 
            count <= 0;  // Reset counter on reset
        else begin
            if (count == SCLK_NEGEDGE) 
                count <= 0;  // Reset after full cycle
            else 
                count <= count + 1;  // Increment counter
        end
    end

    // Generate serial clock signal (sclk) based on edge detection
    always @(posedge clk) begin
        if (risingEdge) 
            sclk <= 1'b1;  // Set high on rising edge
        else if (fallingEdge) 
            sclk <= 1'b0;  // Set low on falling edge
    end

    // One-second timer logic
    always @(posedge clk) begin
        if (reset_n == 1'b0) 
            countOneSec <= 0;  // Reset counter on reset
        else begin
            if (countOneSec == ONESEC_COUNT) 
                countOneSec <= 0;  // Reset after 1 second
            else 
                countOneSec <= countOneSec + 1;  // Increment counter
        end
    end

    // Extract 8-bit sensor value from stored data
    always @(posedge clk) begin
        sensor_val <= serialData[11:4];  // Extract relevant bits for display
    end

endmodule
