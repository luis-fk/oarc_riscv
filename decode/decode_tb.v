//Comandos Wind:

//iverilog -o wave.vvp decode_tb.v ExtendImm.v decode.v flopenrc.v ./BancoRegistradores/BancoRegistradores.v ./BancoRegistradores/Codificador.v ./BancoRegistradores/Mux32x64bits.v ./BancoRegistradores/RegistradorZero.v ./BancoRegistradores/Registrador.v

//vvp wave.vvp

//gtkwave wave.vcd


//Linux: make


`timescale 1ns / 1ps

module decode_tb;
    reg clock;
    reg reset;
    reg [31:0] InstrF;
    reg [63:0] PCF;
    reg [63:0] PCPlus4F;
    reg [1:0] ImmSrcD;
    reg [63:0] ResultW;
    reg [4:0] reg_to_write_src;
    reg WriteEnable;
    reg FlushD;
    reg StallD;

    wire [6:0] opcode;
    wire [2:0] func3;
    wire [6:0] func7;
    wire [63:0] read_data1;
    wire [63:0] read_data2;
    wire [63:0] PCD;
    wire [4:0] Rs1D;
    wire [4:0] Rs2D;
    wire [4:0] RdD;
    wire [63:0] ImmExtD;
    wire [63:0] PCPlus4D;

    decode uut (
        .clock(clock),
        .reset(reset),
        .InstrF(InstrF),
        .PCF(PCF),
        .PCPlus4F(PCPlus4F),
        .ImmSrcD(ImmSrcD),
        .ResultW(ResultW),
        .reg_to_write_src(reg_to_write_src),
        .WriteEnable(WriteEnable),
        .FlushD(FlushD),
        .StallD(StallD),
        .opcode(opcode),
        .func3(func3),
        .func7(func7),
        .read_data1(read_data1),
        .read_data2(read_data2),
        .PCD(PCD),
        .Rs1D(Rs1D),
        .Rs2D(Rs2D),
        .RdD(RdD),
        .ImmExtD(ImmExtD),
        .PCPlus4D(PCPlus4D)
    );

    // Clock generation
    always #5 clock = ~clock;

    initial begin
        // Dump para GTKWave
        $dumpfile("wave.vcd");
        $dumpvars(0, decode_tb);
        // Inicializa o clock e reset
        clock = 0;
        reset = 1;
        FlushD = 0;
        StallD = 0;
        ImmSrcD = 2'b00; // Inicializando o ImmSrcD
        ResultW = 0;
        reg_to_write_src = 0;
        WriteEnable = 0;
        InstrF = 0;
        PCF = 0;
        PCPlus4F = 0;

        // Reset ativo por 10 ns
        #10 reset = 0;

        // Instrução 1: LW no registrador 10 (carrega valor 10)
        // InstrF = {imm[11:0], rs1[4:0], func3[2:0], rd[4:0], opcode[6:0]}
        InstrF = 32'b000000000101_00000_010_01010_0000011; // LW, rs1 = x0, rd = x10, imm = 5
        PCF = 64'd4;
        PCPlus4F = 64'd8;
        reg_to_write_src = 32'd10;
        ResultW = 3'd5;
        WriteEnable = 1;
        #10;

        // Instrução 2: LW no registrador 11 (carrega valor 11)
        InstrF = 32'b000000001100_00000_010_01011_0000011; // LW, rs1 = x0, rd = x11, imm = 12
        PCF = 64'd8;
        PCPlus4F = 64'd12;
        reg_to_write_src = 32'd11;
        ResultW = 4'd12;
        WriteEnable = 1;
        #10;

        // Instrução 3: ADD (x12 = x10 + x11)
        InstrF = 32'b0000000_01011_01010_000_01100_0110011; // ADD, rs1 = x10, rs2 = x11, rd = x12
        PCF = 64'd12;
        PCPlus4F = 64'd16;
        reg_to_write_src = 32'd12;
        ResultW = 5'd17;
        WriteEnable = 1;
        #10;

        // Instrução 4: SUB (x13 = x10 - x11)
        InstrF = 32'b0100000_01011_01010_000_01101_0110011; // SUB, rs1 = x10, rs2 = x11, rd = x13
        PCF = 64'd16;
        PCPlus4F = 64'd20;
        reg_to_write_src = 32'd13;
        WriteEnable = 1;
        ResultW = -7;
        #30;

        // Finalizar simulação
        #20 $finish;
    end
endmodule
