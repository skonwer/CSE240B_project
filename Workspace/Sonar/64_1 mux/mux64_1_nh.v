module mux64_1(
    input [63:0] in,
    input [5:0] select, // 6 bits needed to select one of 64 inputs
    output reg out
);

always @(*) begin
    case (select)
        6'b000000: out = in[0];
        6'b000001: out = in[1];
        6'b000010: out = in[2];
        6'b000011: out = in[3];
        6'b000100: out = in[4];
        6'b000101: out = in[5];
        6'b000110: out = in[6];
        6'b000111: out = in[7];
        6'b001000: out = in[8];
        6'b001001: out = in[9];
        6'b001010: out = in[10];
        6'b001011: out = in[11];
        6'b001100: out = in[12];
        6'b001101: out = in[13];
        6'b001110: out = in[14];
        6'b001111: out = in[15];
        6'b010000: out = in[16];
        6'b010001: out = in[17];
        6'b010010: out = in[18];
        6'b010011: out = in[19];
        6'b010100: out = in[20];
        6'b010101: out = in[21];
        6'b010110: out = in[22];
        6'b010111: out = in[23];
        6'b011000: out = in[24];
        6'b011001: out = in[25];
        6'b011010: out = in[26];
        6'b011011: out = in[27];
        6'b011100: out = in[28];
        6'b011101: out = in[29];
        6'b011110: out = in[30];
        6'b011111: out = in[31];
        6'b100000: out = in[32];
        6'b100001: out = in[33];
        6'b100010: out = in[34];
        6'b100011: out = in[35];
        6'b100100: out = in[36];
        6'b100101: out = in[37];
        6'b100110: out = in[38];
        6'b100111: out = in[39];
        6'b101000: out = in[40];
        6'b101001: out = in[41];
        6'b101010: out = in[42];
        6'b101011: out = in[43];
        6'b101100: out = in[44];
        6'b101101: out = in[45];
        6'b101110: out = in[46];
        6'b101111: out = in[47];
        6'b110000: out = in[48];
        6'b110001: out = in[49];
        6'b110010: out = in[50];
        6'b110011: out = in[51];
        6'b110100: out = in[52];
        6'b110101: out = in[53];
        6'b110110: out = in[54];
        6'b110111: out = in[55];
        6'b111000: out = in[56];
        6'b111001: out = in[57];
        6'b111010: out = in[58];
        6'b111011: out = in[59];
        6'b111100: out = in[60];
        6'b111101: out = in[61];
        6'b111110: out = in[62];
        6'b111111: out = in[63];
        default: out = 1'b0; // Default case
    endcase
end

endmodule