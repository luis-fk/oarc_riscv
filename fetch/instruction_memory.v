module instructions_memory(
    input [10:0] address, //saida da ula
    output [31:0] read_data // read data
);
   reg [31:0] Memory [2047:0];

   initial begin
    /*
    Data Memory -> Valores que serão adicionados no banco de registradores
    */
    // lw x6, 0(x0)
    //Estrutura da instrução de load = {imm[11:0], rs1, 010, rd, 0000011}
     Memory[0] = 32'b000000000000_00000_010_00110_0000011; 

    // sd x6, 64(x0)
    //Estrutura da instrução = {offset[11:5], rs2, rs1, 010, offset[4:0], 0100011}
     Memory[1] = 32'b0000010_00000_00000_010_00000_0100011;
     Memory[2] = 32'd3;
     Memory[3] = 32'd4;
     Memory[4] = 32'd5;
     Memory[5] = 32'd6;
     Memory[6] = 32'd7;
     Memory[20] = 32'd20;
     Memory[21] = 32'd21;
     Memory[22] = 32'd22;
     Memory[23] = 32'd23;
     Memory[24] = 32'd24;
     Memory[25] = 32'd25;
     Memory[26] = 32'd26;
     Memory[27] = 32'd27;
     Memory[28] = 32'd28;
   end

   assign read_data = Memory[address];  
endmodule
