// 8-bit Barrel Shifter Module
module barrel_shift_8(
    input   [7:0] inputData,
    input   [2:0] shiftVal,
    output reg [7:0] outputData
);

    // Use a case statement to simplify the logic
    always @(inputData, shiftVal) begin
        case (shiftVal)
            3'b000: outputData = inputData; // No shift
            3'b001: outputData = {inputData[6:0], inputData[7]}; // Shift left by 1
            3'b010: outputData = {inputData[5:0], inputData[7:6]}; // Shift left by 2
            3'b011: outputData = {inputData[4:0], inputData[7:5]}; // Shift left by 3
            3'b100: outputData = {inputData[3:0], inputData[7:4]}; // Shift left by 4
            3'b101: outputData = {inputData[2:0], inputData[7:3]}; // Shift left by 5
            3'b110: outputData = {inputData[1:0], inputData[7:2]}; // Shift left by 6
            3'b111: outputData = {inputData[0], inputData[7:1]}; // Shift left by 7
            default: outputData = inputData; // Default case, no shift
        endcase
    end

endmodule

// 32-bit Barrel Shifter Module
module barrel_shift_32(
    input   [31:0] inputData,
    input   [4:0] shiftVal,
    output reg [31:0] outputData
);

    // Divide the 32-bit input into four 8-bit segments
    wire [7:0] segment1, segment2, segment3, segment4;
    assign segment1 = inputData[31:24];
    assign segment2 = inputData[23:16];
    assign segment3 = inputData[15:8];
    assign segment4 = inputData[7:0];

    // Outputs from each 8-bit shifter
    wire [7:0] shifted1, shifted2, shifted3, shifted4;

    // Instantiate 8-bit shifters for each segment
    barrel_shift_8 shifter1(segment1, shiftVal[2:0], shifted1);
    barrel_shift_8 shifter2(segment2, shiftVal[2:0], shifted2);
    barrel_shift_8 shifter3(segment3, shiftVal[2:0], shifted3);
    barrel_shift_8 shifter4(segment4, shiftVal[2:0], shifted4);

    // Handle shifts that cross segment boundaries
    always @(inputData, shiftVal) begin
        if (shiftVal < 8) begin
            // Shift within the same segment
            outputData = {shifted1, shifted2, shifted3, shifted4};
        end else if (shiftVal < 16) begin
            // Shift across segment boundaries
            outputData = {shifted2, shifted3, shifted4, shifted1};
        end else if (shiftVal < 24) begin
            outputData = {shifted3, shifted4, shifted1, shifted2};
        end else begin
            outputData = {shifted4, shifted1, shifted2, shifted3};
        end
    end

endmodule

// 32-bit Barrel Shifter with Rotation Control Module
module barrel_shift_32_w_rotation_ctrl(
    input   sel_left_or_right_rotate, // 1 for left rotation, 0 for right rotation
    input   [31:0] inputData,
    input   [4:0] shiftVal,
    output reg [31:0] outputData
);

    // Use the existing 32-bit barrel shifter for left rotation
    wire [31:0] leftRotatedData;
    barrel_shift_32 leftShifter(inputData, shiftVal, leftRotatedData);

    // Perform right rotation by reversing the input and shifting left
    wire [31:0] reversedInput;
    assign reversedInput = {inputData[0], inputData[31:1]};

    wire [31:0] rightRotatedReversedData;
    barrel_shift_32 rightShifter(reversedInput, shiftVal, rightRotatedReversedData);

    wire [31:0] rightRotatedData;
    assign rightRotatedData = {rightRotatedReversedData[0], rightRotatedReversedData[31:1]};

    // Select between left and right rotation based on sel_left_or_right_rotate
    always @(inputData, shiftVal, sel_left_or_right_rotate) begin
        if (sel_left_or_right_rotate) begin
            outputData = leftRotatedData;
        end else begin
            outputData = rightRotatedData;
        end
    end

endmodule