module barrel_shift_32_w_rotation_ctrl(
    input sel_left_or_right_rotate, // 0 for left shift, 1 for left rotate, 2 for right shift, 3 for right rotate
    input [31:0] inputData,
    input [4:0] shiftVal,
    output reg [31:0] outputData
);

    reg [31:0] tempData;

    always @(sel_left_or_right_rotate, inputData, shiftVal) begin
        case (sel_left_or_right_rotate)
            0: // Left shift
                outputData = inputData << shiftVal;
            1: // Left rotate
                outputData = {inputData[shiftVal:31], inputData[0:shiftVal - 1]};
            2: // Right shift
                outputData = inputData >> shiftVal;
            3: // Right rotate
                outputData = {inputData[31 - shiftVal + 1:31], inputData[0:31 - shiftVal]};
            default: // Handle invalid input
                outputData = inputData; // Default behavior
        endcase
    end

endmodule