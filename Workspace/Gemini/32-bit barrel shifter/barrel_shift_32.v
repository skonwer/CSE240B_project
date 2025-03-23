module barrel_shift_8(
    input  [7:0] inputData,
    input  [2:0] shiftVal,
    output [7:0] outputData
);

    wire [7:0] shifted_1;
    wire [7:0] shifted_2;
    wire [7:0] shifted_4;

    assign shifted_1 = (shiftVal[0]) ? {inputData[6:0], inputData[7]} : inputData;
    assign shifted_2 = (shiftVal[1]) ? {shifted_1[5:0], shifted_1[7:6]} : shifted_1;
    assign shifted_4 = (shiftVal[2]) ? {shifted_2[3:0], shifted_2[7:4]} : shifted_2;

    assign outputData = shifted_4;

endmodule

module barrel_shift_32(
    input  [31:0] inputData,
    input  [4:0] shiftVal,
    output [31:0] outputData
);

    wire [31:0] shifted_8;
    wire [31:0] shifted_16;

    wire [7:0] block0_in, block1_in, block2_in, block3_in;
    wire [7:0] block0_out, block1_out, block2_out, block3_out;

    assign block0_in = inputData[7:0];
    assign block1_in = inputData[15:8];
    assign block2_in = inputData[23:16];
    assign block3_in = inputData[31:24];

    barrel_shift_8 shift_block0 (
        .inputData(block0_in),
        .shiftVal(shiftVal[2:0]),
        .outputData(block0_out)
    );

    barrel_shift_8 shift_block1 (
        .inputData(block1_in),
        .shiftVal(shiftVal[2:0]),
        .outputData(block1_out)
    );

    barrel_shift_8 shift_block2 (
        .inputData(block2_in),
        .shiftVal(shiftVal[2:0]),
        .outputData(block2_out)
    );

    barrel_shift_8 shift_block3 (
        .inputData(block3_in),
        .shiftVal(shiftVal[2:0]),
        .outputData(block3_out)
    );

    assign shifted_8 = {block3_out, block2_out, block1_out, block0_out};

    wire [1:0] rotate_8_shift = shiftVal[4:3];
    assign shifted_16 = (rotate_8_shift[1]) ? {shifted_8[15:0], shifted_8[31:16]} : shifted_8;
    assign outputData = (rotate_8_shift[0]) ? {shifted_16[23:0], shifted_16[31:24]} : shifted_16;

endmodule

module barrel_shift_32_w_rotation_ctrl(
    input sel_left_or_right_rotate,
    input [31:0] inputData,
    input [4:0] shiftVal,
    output [31:0] outputData
);

    wire [31:0] shifted_data;
    integer i;
    wire [31:0] rotated_data;

    barrel_shift_32 shifter (
        .inputData(inputData),
        .shiftVal(shiftVal),
        .outputData(shifted_data)
    );

    always @(*) begin
        if (sel_left_or_right_rotate) begin
            rotated_data = shifted_data;
        end else begin
            rotated_data = shifted_data;
            for (i = 0; i < 32; i = i + 1) begin
                if (i < shiftVal) begin
                    rotated_data[i] = shifted_data[32 - shiftVal + i];
                end else begin
                    rotated_data[i] = shifted_data[i - shiftVal];
                end
            end
        end
    end

    assign outputData = rotated_data;

endmodule