module decoder2_4(
    input [1:0] in,
    output reg [3:0] out
);

    always @(in) begin
        case (in)
            2'b00: out = 4'b0001;
            2'b01: out = 4'b0010;
            2'b10: out = 4'b0100;
            2'b11: out = 4'b1000;
            default: out = 4'b0000;
        endcase
    end

endmodule

module decoder3_8(
    input [2:0] in,
    output reg [7:0] out
);

    wire [3:0] dec0_out, dec1_out;

    decoder2_4 dec0(
        .in(in[1:0]),
        .out(dec0_out)
    );

    decoder2_4 dec1(
        .in(in[1:0]),
        .out(dec1_out)
    );

    always @(in, dec0_out, dec1_out) begin
        if (~in[2]) begin
            out[3:0] = dec0_out;
            out[7:4] = 4'b0000;
        end else begin
            out[7:4] = dec1_out;
            out[3:0] = 4'b0000;
        end
    end

endmodule

module decoder5_32(
    input [4:0] in,
    output reg [31:0] out
);

    wire [7:0] dec0_out, dec1_out, dec2_out, dec3_out;

    decoder3_8 dec0(
        .in(in[2:0]),
        .out(dec0_out)
    );

    decoder3_8 dec1(
        .in(in[2:0]),
        .out(dec1_out)
    );

    decoder3_8 dec2(
        .in(in[2:0]),
        .out(dec2_out)
    );

    decoder3_8 dec3(
        .in(in[2:0]),
        .out(dec3_out)
    );

    always @(in, dec0_out, dec1_out, dec2_out, dec3_out) begin
        case ({in[4:3]})
            2'b00: begin
                out[7:0] = dec0_out;
                out[31:8] = 24'b0;
            end
            2'b01: begin
                out[15:8] = dec1_out;
                out[31:16] = 16'b0;
                out[7:0] = 8'b0;
            end
            2'b10: begin
                out[23:16] = dec2_out;
                out[31:24] = 8'b0;
                out[15:0] = 16'b0;
            end
            2'b11: begin
                out[31:24] = dec3_out;
                out[23:0] = 24'b0;
            end
            default: out = 32'b0;
        endcase
    end

endmodule