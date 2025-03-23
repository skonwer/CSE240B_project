// 2-to-1 Multiplexer
module mux2_1(
    input in1,
    input in2,
    input select,
    output out
);
    assign out = (select) ? in2 : in1;
endmodule

// 4-to-1 Multiplexer
module mux4_1(
    input [3:0] in,
    input [1:0] select,
    output out
);
    wire mid1, mid2;

    mux2_1 mux1(in[1], in[0], select[0], mid1);
    mux2_1 mux2(in[3], in[2], select[0], mid2);

    mux2_1 mux3(mid1, mid2, select[1], out);
endmodule

// 8-to-1 Multiplexer
module mux8_1(
    input [7:0] in,
    input [2:0] select,
    output out
);
    wire mid1, mid2;

    mux4_1 mux1(in[3:0], select[1:0], mid1);
    mux4_1 mux2(in[7:4], select[1:0], mid2);

    mux2_1 mux3(mid1, mid2, select[2], out);
endmodule

// 16-to-1 Multiplexer
module mux16_1(
    input [15:0] in,
    input [3:0] select,
    output out
);
    wire mid1, mid2;

    mux8_1 mux1(in[7:0], select[2:0], mid1);
    mux8_1 mux2(in[15:8], select[2:0], mid2);

    mux2_1 mux3(mid1, mid2, select[3], out);
endmodule

// 32-to-1 Multiplexer
module mux32_1(
    input [31:0] in,
    input [4:0] select,
    output out
);
    wire mid1, mid2;

    mux16_1 mux1(in[15:0], select[3:0], mid1);
    mux16_1 mux2(in[31:16], select[3:0], mid2);

    mux2_1 mux3(mid1, mid2, select[4], out);
endmodule

// 64-to-1 Multiplexer
module mux64_1(
    input [63:0] in,
    input [5:0] select,
    output out
);
    wire mid1, mid2;

    mux32_1 mux1(in[31:0], select[4:0], mid1);
    mux32_1 mux2(in[63:32], select[4:0], mid2);

    mux2_1 mux3(mid1, mid2, select[5], out);
endmodule