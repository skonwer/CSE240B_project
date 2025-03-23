module barrel_shift_32_w_rotation_ctrl(
    input sel_left_or_right_rotate, // 0 for left rotate, 1 for right rotate
    input [31:0] inputData,
    input [4:0] shiftVal,
    output reg [31:0] outputData
);
    always @(*) begin
        if (sel_left_or_right_rotate == 1'b0) begin
            // Left rotate
            outputData = (inputData << shiftVal) | (inputData >> (32 - shiftVal));
        end else begin
            // Right rotate
            outputData = (inputData >> shiftVal) | (inputData << (32 - shiftVal));
        end
    end
endmodule