module decoder2_4(
    input [1:0] in,
    output [3:0] out
);
    assign out[0] = ~in[1] & ~in[0];
    assign out[1] = ~in[1] & in[0];
    assign out[2] = in[1] & ~in[0];
    assign out[3] = in[1] & in[0];
endmodule

module decoder3_8(
    input [2:0] in,
    output [7:0] out
);
    wire [3:0] lower, upper;

    decoder2_4 lower_decoder(
        .in(in[1:0]),
        .out(lower)
    );

    decoder2_4 upper_decoder(
        .in(in[1:0]),
        .out(upper)
    );

    assign out[3:0] = lower & {4{~in[2]}};
    assign out[7:4] = upper & {4{in[2]}};
endmodule

module decoder5_32(
    input [4:0] in,
    output [31:0] out
);
    wire [3:0] enable;
    wire [7:0] outputs [3:0];

    // Instantiate the 2-to-4 decoder for enabling the 3-to-8 decoders
    decoder2_4 enable_decoder(
        .in(in[4:3]),
        .out(enable)
    );

    // Instantiate the 4 3-to-8 decoders
    decoder3_8 decoder_0(
        .in(in[2:0]),
        .out(outputs[0])
    );

    decoder3_8 decoder_1(
        .in(in[2:0]),
        .out(outputs[1])
    );

    decoder3_8 decoder_2(
        .in(in[2:0]),
        .out(outputs[2])
    );

    decoder3_8 decoder_3(
        .in(in[2:0]),
        .out(outputs[3])
    );

    // Combine the outputs based on the enable signals
    assign out[7:0]   = outputs[0] & {8{enable[0]}};
    assign out[15:8]  = outputs[1] & {8{enable[1]}};
    assign out[23:16] = outputs[2] & {8{enable[2]}};
    assign out[31:24] = outputs[3] & {8{enable[3]}};
endmodule