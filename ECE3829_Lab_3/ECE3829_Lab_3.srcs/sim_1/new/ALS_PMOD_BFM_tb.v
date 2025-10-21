`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/17/2025 10:03:42 PM
// Design Name: 
// Module Name: test_ALS_PMOD_BFM
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

module test_ALS_PMOD_BFM();
    // Signal declarations
    reg SCLK;               // Serial clock
    reg CS_N;               // Active-low chip select
    wire SDO;               // Serial data output from DUT
    reg [7:0] data_in;      // 8-bit data input to DUT
   
    // Variables for test comparison
    reg [7:0] data_expect;  // Expected sensor data
    reg [14:0] data_receive; // Captured 15-bit serial data
    integer i = 0;
    integer differ = 1;     // Multiplier for generating test data
   
    // Instantiate the sensor module under test (DUT)
    ALS_PMOD_BFM dut(
        .SCLK(SCLK),
        .CS_N(CS_N),
        .data_in(data_in),
        .SDO(SDO)
    );
   
    // Clock generation: Toggle SCLK every 500 ns
    always begin
        #500 SCLK = ~SCLK;
    end
   
    // Main simulation block
    initial begin
        // Initialize signals
        SCLK = 1'b0;
        CS_N = 1'b1;
        data_receive = 15'd0;
        #2000;
       
        // Run 4 test iterations
        repeat (4) begin
            // Generate expected data and load into data_in
            data_expect = 8'b01010101 * differ;
            data_in = data_expect;
            #1000 CS_N = 1'b0;  // Activate chip select to start shifting
            data_receive = 15'd0; // Clear captured data
            
            // Capture 16 serial bits from SDO on each falling edge of SCLK
            for (i = 0; i < 16; i = i + 1) begin
                @(negedge SCLK);
                data_receive = {data_receive[13:0], SDO};
            end
            CS_N = 1'b1;  // Deactivate chip select to stop shifting
           
            // Compare extracted 8-bit data (from bits [11:4]) to expected value
            if (data_receive[11:4] == data_expect) begin
                $display("PASS: Expected = %h, Received = %h at time = %t ps", 
                         data_expect, data_receive[11:4], $realtime);
            end else begin
                $display("FAIL: Expected = %h, Received = %h at time = %t ps", 
                         data_expect, data_receive[11:4], $realtime);
            end
           
            differ = differ + 1; // Update multiplier for next test case
            #2000; // Wait before next iteration
        end
        $stop; // End simulation
    end
   
endmodule