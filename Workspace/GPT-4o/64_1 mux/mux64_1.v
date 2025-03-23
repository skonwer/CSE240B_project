module mux2_1(in1, in2, select, out);
    input in1, in2;
    input select;
    output out;

    assign out = select ? in2 : in1;

endmodule

module mux4_1(in, select, out);
    input [3:0] in;
    input [1:0] select;
    output out;

    wire mux_out1, mux_out2;

    // First level of 2-to-1 multiplexers
    mux2_1 mux1 (.in1(in[0]), .in2(in[1]), .select(select[0]), .out(mux_out1));
    mux2_1 mux2 (.in1(in[2]), .in2(in[3]), .select(select[0]), .out(mux_out2));

    // Second level of 2-to-1 multiplexer
    mux2_1 mux3 (.in1(mux_out1), .in2(mux_out2), .select(select[1]), .out(out));

endmodule

module mux8_1(in, select, out);
    input [7:0] in;
    input [2:0] select;
    output out;

    wire mux_out1, mux_out2;

    // First level of 4-to-1 multiplexers
    mux4_1 mux1 (.in(in[3:0]), .select(select[1:0]), .out(mux_out1));
    mux4_1 mux2 (.in(in[7:4]), .select(select[1:0]), .out(mux_out2));

    // Second level of 2-to-1 multiplexer
    mux2_1 mux3 (.in1(mux_out1), .in2(mux_out2), .select(select[2]), .out(out));

endmodule

module mux16_1(in, select, out);
    input [15:0] in;
    input [3:0] select;
    output out;

    wire mux_out1, mux_out2;

    // First level of 8-to-1 multiplexers
    mux8_1 mux1 (.in(in[7:0]), .select(select[2:0]), .out(mux_out1));
    mux8_1 mux2 (.in(in[15:8]), .select(select[2:0]), .out(mux_out2));

    // Second level of 2-to-1 multiplexer
    mux2_1 mux3 (.in1(mux_out1), .in2(mux_out2), .select(select[3]), .out(out));

endmodule

module mux32_1(in, select, out);
    input [31:0] in;
    input [4:0] select;
    output out;

    wire mux_out1, mux_out2;

    // First level of 16-to-1 multiplexers
    mux16_1 mux1 (.in(in[15:0]), .select(select[3:0]), .out(mux_out1));
    mux16_1 mux2 (.in(in[31:16]), .select(select[3:0]), .out(mux_out2));

    // Second level of 2-to-1 multiplexer
    mux2_1 mux3 (.in1(mux_out1), .in2(mux_out2), .select(select[4]), .out(out));

endmodule

module mux64_1(in, select, out);
    input [63:0] in;
    input [5:0] select;
    output out;

    wire mux_out1, mux_out2;

    // First level of 32-to-1 multiplexers
    mux32_1 mux1 (.in(in[31:0]), .select(select[4:0]), .out(mux_out1));
    mux32_1 mux2 (.in(in[63:32]), .select(select[4:0]), .out(mux_out2));

    // Second level of 2-to-1 multiplexer
    mux2_1 mux3 (.in1(mux_out1), .in2(mux_out2), .select(select[5]), .out(out));

endmodule