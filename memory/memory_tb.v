// //iverilog -o wave.vvp data_memory.v memory_tb.v memory.v flopr.v

// vvp wave.vvp

// gtkwave wave.vcd

//Linux: make

`timescale 1ns / 1ps

module memory_tb;

    reg clock;
    reg reset;
    reg [63:0] ALUResultE;
    reg [63:0] WriteDataE;
    reg [4:0] RdE;
    reg [63:0] PCPlus4E;
    reg MemWriteM;

    wire [4:0] RdM;
    wire [63:0] PCPlus4M;
    wire [63:0] RD_Memory;
    wire [63:0] ALUResultM;

    // Instancia o módulo memory
    memory uut (
        .clock(clock),
        .reset(reset),
        .ALUResultE(ALUResultE),
        .WriteDataE(WriteDataE),
        .RdE(RdE),
        .PCPlus4E(PCPlus4E),
        .MemWriteM(MemWriteM),
        .RdM(RdM),
        .PCPlus4M(PCPlus4M),
        .RD_Memory(RD_Memory),
        .ALUResultM(ALUResultM)
    );

    // Gera clock
    always #5 clock = ~clock;

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, memory_tb);
        // Inicialização
        clock = 0;
        reset = 1;
        ALUResultE = 0;
        WriteDataE = 0;
        RdE = 0;
        PCPlus4E = 0;
        MemWriteM = 0;

        // Solta o reset
        #10 reset = 0;

        // Teste de escrita na memória
        #10 ALUResultE = 64'h000000000000000A;  // Endereço
        WriteDataE = 64'hDEADBEEFDEADBEEF;     // Dado para escrever
        RdE = 5'b00001;
        PCPlus4E = 64'h0000000000000004;
        MemWriteM = 1;                         // Habilita escrita na memória

        #20 MemWriteM = 0;                     // Desabilita escrita

        // Teste de leitura da memória
        #10 ALUResultE = 64'h000000000000000A; // Endereço já escrito
        WriteDataE = 64'h0;
        RdE = 5'b00010;

        // Aguarda alguns ciclos e verifica resultados
        #30;
        $display("ALUResultM: %h", ALUResultM);
        $display("PCPlus4M: %h", PCPlus4M);
        $display("RD_Memory: %h", RD_Memory);

        // Finaliza simulação
        #50 $finish;
    end

endmodule
