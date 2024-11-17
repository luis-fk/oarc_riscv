`timescale 1ns / 1ps

module execute_tb;

    // Declaração de sinais
    reg clock;
    reg reset;
    reg [2:0] ALUControlE;
    reg ALUSrcE;
    reg [63:0] ALUResultM;
    reg [63:0] ResultW;
    reg FlushE;
    reg [1:0] ForwardAE;
    reg [1:0] ForwardBE;
    reg [63:0] read_data1;
    reg [63:0] read_data2;
    reg [63:0] PCD;
    reg [4:0] RdD;
    reg [63:0] ImmExtD;
    reg [63:0] PCPlus4D;
    reg [4:0] Rs1D;
    reg [4:0] Rs2D;

    // Saídas
    wire zeroE;
    wire [63:0] PCTargetE;
    wire [63:0] ALUResultE;
    wire [63:0] WriteDataE;
    wire [4:0] RdE;
    wire [63:0] PCPlus4E;

    // Instanciando o módulo execute
    execute uut (
        .clock(clock),
        .reset(reset),
        .ALUControlE(ALUControlE),
        .ALUSrcE(ALUSrcE),
        .ALUResultM(ALUResultM),
        .ResultW(ResultW),
        .FlushE(FlushE),
        .ForwardAE(ForwardAE),
        .ForwardBE(ForwardBE),
        .read_data1(read_data1),
        .read_data2(read_data2),
        .PCD(PCD),
        .RdD(RdD),
        .ImmExtD(ImmExtD),
        .PCPlus4D(PCPlus4D),
        .Rs1D(Rs1D),
        .Rs2D(Rs2D),
        .zeroE(zeroE),
        .PCTargetE(PCTargetE),
        .ALUResultE(ALUResultE),
        .WriteDataE(WriteDataE),
        .RdE(RdE),
        .PCPlus4E(PCPlus4E)
    );

    // Geração do clock
    always begin
        #5 clock = ~clock; // Toggle a cada 5 unidades de tempo
    end

    // Inicializando sinais e aplicando estímulos
    initial begin
        // Inicialização
        clock = 0;
        reset = 0;
        ALUControlE = 4'b0000;
        ALUSrcE = 0;
        ALUResultM = 64'b0;
        ResultW = 64'b0;
        FlushE = 0;
        ForwardAE = 2'b00;
        ForwardBE = 2'b00;
        read_data1 = 64'hA5A5A5A5A5A5A5A5;
        read_data2 = 64'h5A5A5A5A5A5A5A5A;
        PCD = 64'h0000000000001000;
        RdD = 5'b00001;
        ImmExtD = 64'h0000000000000010;
        PCPlus4D = 64'h0000000000001004;
        Rs1D = 5'b00001;
        Rs2D = 5'b00010;

        // Reset
        reset = 1;
        #10 reset = 0;

        // Teste 1: ALUControlE = 0000, ALUSrcE = 0 (Read data2)
        ALUControlE = 4'b0000;
        ALUSrcE = 0;
        ForwardAE = 2'b00; // Sem forward
        ForwardBE = 2'b00; // Sem forward
        #10;

        // Teste 2: ALUControlE = 0001, ALUSrcE = 1 (Immediate)
        ALUControlE = 4'b0001;
        ALUSrcE = 1;
        #10;

        // Teste 3: Forwarding de ResultW
        ForwardAE = 2'b01; // Forward de ResultW para RS1
        ForwardBE = 2'b01; // Forward de ResultW para RS2
        ResultW = 64'hDEADBEEFDEADBEEF;
        #10;

        // Teste 4: FlushE ativo
        FlushE = 1;
        #10;
        FlushE = 0;

        // Teste 5: ALUResultM como entrada para ForwardAE
        ALUResultM = 64'h123456789ABCDEF0;
        ForwardAE = 2'b10; // Forward de ALUResultM para RS1
        #10;

        // Teste 6: Operação ALU com diferentes ALUControlE
        ALUControlE = 4'b0010; // Soma
        #10;
        ALUControlE = 4'b0110; // Subtração
        #10;

        // Finalizando o teste
        $finish;
    end

    // Monitoramento das saídas
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, execute_tb);
        $monitor("Time: %0t | ALUResultE: %h | WriteDataE: %h | PCTargetE: %h | ZeroE: %b",
                 $time, ALUResultE, WriteDataE, PCTargetE, zeroE);
    end

endmodule
