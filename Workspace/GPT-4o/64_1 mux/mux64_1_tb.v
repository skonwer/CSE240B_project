`timescale 1ns/1ps

`include "mux64_1.v" 

module testbench;

// Testbench signals
reg [5:0] sel;
reg [63:0] in;
wire out;

// Instantiate the mux64_1 module
mux64_1 uut (
    .select(sel),
    .in(in),
    .out(out)
);
    integer i;
// Test procedure
initial begin
    // Initialize inputs
    sel = 0;
    in = 64'hA5A5_A5A5_F0F0_0F0F; // Example input pattern, hexadecimal for clarity

    // Initialize the test loop

    for (i = 0; i < 64; i = i + 1) begin
        #10 sel = i;  // Set selection to current index
        #10 if (out == in[sel])  // Check if the output matches the expected input
            $display("Test %d passed!: %d", i, out);
            else
            $display("Test %d failed: %d", i, out);
    end

    // End of tests
    #10 $finish;
end

endmodule