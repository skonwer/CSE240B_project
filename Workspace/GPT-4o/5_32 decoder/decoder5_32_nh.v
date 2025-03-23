module decoder5_32(input [4:0] in, output reg [31:0] out);
    always @(*) begin
        out = 32'b0; // Initialize output to all zeros
        out[in] = 1'b1; // Set the bit corresponding to the input value to 1
    end
endmodule