module testbench;

    reg clk;                // Clock signal for simulation
    reg reset;              // Reset signal for simulation
    wire [31:0] count;      // Wire to observe the count output

    // Instantiate the top-level module (which contains check_clock)
    top uut (
        .clk(clk),
        .count(count)
    );

    // Generate a clock signal (e.g., 25 MHz or whatever your clock is)
    initial begin
        clk = 0;
        forever #20 clk = ~clk; // Toggle clock every 20 ns (50 MHz clock)
    end

    // Initialize reset and simulation behavior
    initial begin
        reset = 1;          // Assert reset initially
        #100;               // Wait for 100 ns to allow reset to propagate
        reset = 0;          // Deassert reset
        
        // Run the simulation for a period of time
        $monitor("At time %t, count = %d", $time, count); // Monitor the count signal
        #1000000;           // Run for 1 second if your clock is 25 MHz
        $finish;            // Finish the simulation
    end
endmodule
