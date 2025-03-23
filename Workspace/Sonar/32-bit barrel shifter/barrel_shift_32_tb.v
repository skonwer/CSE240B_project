`timescale 1ns / 1ps

`include "barrel_shift_32_nh.v"

module barrel_shift_tb;
    // Testbench signals
    reg sel_left_or_right_rotate;
    reg [31:0] inputData;
    reg [4:0] shiftVal;
    wire [31:0] outputData;
    
    // Instantiate the DUT (Device Under Test)
    barrel_shift_32_w_rotation_ctrl uut (
        .sel_left_or_right_rotate(sel_left_or_right_rotate),
        .inputData(inputData),
        .shiftVal(shiftVal),
        .outputData(outputData)
    );
    
    // Test procedure
    initial begin
        $monitor("Time=%0t sel=%b input=%h shift=%d output=%h", 
                  $time, sel_left_or_right_rotate, inputData, shiftVal, outputData);
        
        // Test case 1: Left rotate by 1
        sel_left_or_right_rotate = 0;
        inputData = 32'hA5A5A5A5;
        shiftVal = 5'd1;
        #10;
        
        // Test case 2: Left rotate by 8
        shiftVal = 5'd8;
        #10;
        
        // Test case 3: Left rotate by 16
        shiftVal = 5'd16;
        #10;
        
        // Test case 4: Right rotate by 1
        sel_left_or_right_rotate = 1;
        shiftVal = 5'd1;
        #10;
        
        // Test case 5: Right rotate by 8
        shiftVal = 5'd8;
        #10;
        
        // Test case 6: Right rotate by 16
        shiftVal = 5'd16;
        #10;
        
        // Test case 7: No shift (0 shift value)
        shiftVal = 5'd0;
        #10;
        
        // Test case 8: Maximum shift (31 bits)
        shiftVal = 5'd31;
        #10;
        
        // End simulation
        $finish;
    end
endmodule
