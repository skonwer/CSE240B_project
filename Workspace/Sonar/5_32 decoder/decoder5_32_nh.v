module decoder5_32(
    input [4:0] in,
    output [31:0] out
);

    assign out = (1 << in);

endmodule