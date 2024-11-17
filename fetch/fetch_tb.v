
//Comandos Wind:

//iverilog -o wave.vvp fetch_tb.v fetch.v flopenr.v instruction_memory.v mux2.v

//vvp wave.vvp

//gtkwave wave.vcd


//Linux: make

`timescale 1ns / 1ps
module fetch_tb;

    // Sinais de entrada do DUT
    reg clock;
    reg reset_pc;
    reg PCSrcE;
    reg StallF;
    reg [63:0] pc_target;

    // Sinais de saída do DUT
    wire [31:0] InstrF;
    wire [63:0] PCF;
    wire [63:0] PCPlus4F;

    // Instanciando o DUT (Device Under Test)
    fetch uut (
        .clock(clock),
        .reset_pc(reset_pc),
        .PCSrcE(PCSrcE),
        .StallF(StallF),
        .pc_target(pc_target),
        .InstrF(InstrF),
        .PCF(PCF),
        .PCPlus4F(PCPlus4F)
    );

    // Geração de clock
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, fetch_tb);
        clock = 0;
        forever #5 clock = ~clock; // Clock de 10 unidades de tempo
    end

    // Estímulos
    initial begin
        // Inicializa os sinais
        reset_pc = 1;
        PCSrcE = 0;
        StallF = 0;
        pc_target = 64'd0;

        // Espera alguns ciclos para o reset
        #10;
        reset_pc = 0;

        // Teste 1: Incremento normal do PC
        #10;
        StallF = 0;    // Sem stall
        PCSrcE = 0;    // PC continua incrementando normalmente

        // Teste 2: Muda o PC com PCSrcE
        #20;
        PCSrcE = 1;    // Altera o PC para pc_target
        pc_target = 64'd20;

        #20
        PCSrcE = 0;

        // Teste 3: Sinal de stall
        #30;
        StallF = 1;    // Mantém o valor atual do PC

        #30
        StallF = 0;

        // Teste 4: Reseta o PC
        #40;
        reset_pc = 1;

        // Fim da simulação
        #50;
        $finish;
    end

    // Monitor para observar os sinais
    initial begin
        $monitor(
            "Time=%0t | reset_pc=%b | PCSrcE=%b | StallF=%b | pc_target=%d | PCF=%d | PCPlus4F=%d | InstrF=%h",
            $time, reset_pc, PCSrcE, StallF, pc_target, PCF, PCPlus4F, InstrF
        );
    end

endmodule
