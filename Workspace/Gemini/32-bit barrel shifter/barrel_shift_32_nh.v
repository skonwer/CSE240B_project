module barrel_shift_32_w_rotation_ctrl(
  input sel_left_or_right_rotate,
  input [31:0] inputData,
  input [4:0] shiftVal,
  output [31:0] outputData
);

  reg [31:0] shifted_data;

  always @* begin
    if (sel_left_or_right_rotate == 1'b1) begin // Right Rotate
      shifted_data = {inputData[shiftVal-1:0], inputData[31:shiftVal]};
    end else begin // Left Rotate
      shifted_data = {inputData[31-shiftVal:0], inputData[31:32-shiftVal]};
    end
  end

  assign outputData = shifted_data;

endmodule