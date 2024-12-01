module instructions_memory(
    input [10:0] address, // endereço fornecido pela ULA
    output [31:0] read_data // instrução a ser lida
);
   reg [31:0] Memory [2047:0];

//    initial begin
//     // Instruções baseadas no programa da imagem
//     Memory[0] = 32'b000000000101_00000_000_00010_0010011; // addi x2, x0, 5
//     Memory[1] = 32'b000000011000_00000_000_00011_0010011; // addi x3, x0, 12
//     Memory[2] = 32'b111110100111_00011_000_00111_0010011; // addi x7, x3, -9
//     Memory[3] = 32'b0000000_00111_00100_110_00100_0110011; // or x4, x7, x2
//     Memory[4] = 32'b0000000_00100_00111_100_00101_0110011; // xor x5, x4, x7
//     Memory[5] = 32'b0000000_00111_00101_000_00101_0110011; // add x5, x5, x7
//     Memory[6] = 32'b0000000_00111_00101_000_00000_1100011; // beq x5, x7, end
//     Memory[7] = 32'b0000000_00010_00100_010_00100_0110011; // slt x4, x2, x7
//     Memory[8] = 32'b0000000_00000_00100_000_01000_1100011; // beq x4, x0, around 0000000_00000_00100_000_01000_1100011
//     Memory[9] = 32'b000000000000_00000_000_00101_0010011; // addi x5, x0, 0
//     Memory[10] = 32'b0000000_00100_00111_010_00100_0110011; // slt x4, x7, x2
//     Memory[11] = 32'b0000000_10010_00111_000_00111_0110011; // add x7, x4, x5
//     Memory[12] = 32'b0100000_00101_00100_000_00111_0110011; // sub x7, x7, x2
//     Memory[13] = 32'b000000000000_00011_010_00000_0100011; // sw x7, 84(x3)
//     Memory[14] = 32'b000000000000_00011_010_00110_0000011; // lw x2, 96(x3)
//     Memory[15] = 32'b0000000_00010_00101_000_00100_0110011; // add x9, x2, x5
//     Memory[16] = 32'b000000000000_00111_000_00011_1101111; // jal x3, end
//     Memory[17] = 32'b000000000001_00000_000_00100_0010011; // addi x4, x0, 1
//     Memory[18] = 32'b0000000_00010_00100_000_00010_0110011; // add x2, x2, x9
//     Memory[19] = 32'b0000000_00001_00000_000_00100_0010011; // addi x4, x0, 1
//     Memory[20] = 32'b100000000000_00000_011_01010_0010111; // lui x5, 0x8000000
//     Memory[21] = 32'b0000000_00101_00000_000_00101_0110011; // slt x6, x5, x4
//     Memory[22] = 32'b0000000_00110_00000_000_00100_1100011; // beq x6, x0, wrong
//     Memory[23] = 32'b101010111100_00000_011_00111_0010111; // lui x9, 0xABCDE
//     Memory[24] = 32'b0000000_00010_00111_000_00010_0110011; // add x2, x2, x9
//     Memory[25] = 32'b000000000000_00011_010_00110_0100011; // sw x2, 40(x3)
//     Memory[26] = 32'b0000000_00010_00010_000_00010_1100011; // beq x2, x2, done
//    end

        initial begin
            Memory[0]  = 32'h00500113; // addi x2, x0, 5
            Memory[4]  = 32'h00C00193; // addi x3, x0, 12
            Memory[8]  = 32'hFF718393; // addi x7, x3, -9
            Memory[12] = 32'h0023E233; // or x4, x7, x2
            Memory[16] = 32'h00B00293; // addi x5, x0, 11
            Memory[20] = 32'h004282B3; // add x5, x5, x4
            Memory[24] = 32'h02728863; // beq x5, x7, end
            Memory[28] = 32'h0041A233; // slt x4, x3, x4
            Memory[32] = 32'h00020463; // beq x4, x0, around
            Memory[36] = 32'h00000293; // addi x5, x0, 0
/*around*/  Memory[40] = 32'h0023A233; // slt x4, x7, x2    
            Memory[44] = 32'h005203B3; // add x7, x4, x5
            Memory[48] = 32'h402383B3; // sub x7, x7, x2    
            Memory[52] = 32'h0471AA23; // sw x7, 84(x3)
            Memory[56] = 32'h06002103; // lw x2, 96(x0)   
            Memory[60] = 32'h005104B3; // add x9, x2, x5
            Memory[64] = 32'h008001EF; // jal x3, end
            Memory[68] = 32'h00100113; // addi x2, x0, 1
/*end*/     Memory[72] = 32'h00910133; // add x2, x2, x9
            Memory[76] = 32'h00100213; // addi x4, x0, 1
            Memory[80] = 32'h800002B7; // lui x5, 0x80000  (Não SUPORTADO)
            Memory[84] = 32'h0042A333; // slt x6, x5, x4
/*wrong*/   Memory[88] = 32'h00030063; // beq x6, x0, wrong
            Memory[92] = 32'hABCDE4B7; // lui x9, 0xABCDE  (Não SUPORTADO)
            Memory[96] = 32'h00910133; // add x2, x2, x9
            Memory[100] = 32'h0421A023; // sw x2, 0x40(x3)
/*done*/    Memory[104] = 32'h00210063; // beq x2, x2, done
        end

   assign read_data = Memory[address];  
endmodule
