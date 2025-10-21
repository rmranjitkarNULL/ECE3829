`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/17/2025 09:02:58 PM
// Design Name: 
// Module Name: ALS_PMOD_BFM
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

module ALS_PMOD_BFM(
    input SCLK,          // Serial clock
    input CS_N,          // Active-low chip select
    input [7:0] data_in, // 8-bit sensor data from testbench
    output reg SDO       // Serial data output
);
   
    reg [14:0] shift_reg; // 15-bit shift register (3 zeros, 8-bit data, 4 zeros)
    reg next_sdo;         // Next serial output bit
   
    localparam TACC = 40; // 40 ns access delay
   
    // On falling edge of SCLK
    always @(negedge SCLK) begin
        if (CS_N == 1'b0) begin // Shifting mode
            if (shift_reg == 15'd0)
                #TACC; // Delay when register is empty
            shift_reg <= {shift_reg[13:0], 1'b0}; // Shift left by 1 bit
            next_sdo <= shift_reg[14];            // Capture MSB for output
        end else begin // Data load mode
            shift_reg <= {3'b000, data_in, 4'b0000}; // Load 15-bit word
            next_sdo = 1'b0;                         // Clear serial output
        end
    end
   
    // Continuous assignment of SDO
    always @(*) begin
        SDO = next_sdo;
    end   

endmodule
