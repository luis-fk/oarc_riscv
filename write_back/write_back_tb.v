//iverilog -o wave.vvp flopr.v write_back.v write_back_tb.v mux3.v
//vvp wave.vvp 
//gtkwave wave.vcd

`timescale 1ns / 1ps

module write_back_tb;

    reg clock;
    reg reset;

    // Entradas do módulo
    reg [63:0] ALUResultM;
    reg [63:0] ReadDataM;
    reg [63:0] PCPlus4M;
    reg [4:0] RdM;
    reg [1:0] ResultSrcW;

    // Saídas do módulo
    wire [4:0] RdW;
    wire [63:0] ResultW;

    // Instancia o módulo write_back
    write_back uut (
        .clock(clock),
        .reset(reset),
        .ALUResultM(ALUResultM),
        .ReadDataM(ReadDataM),
        .PCPlus4M(PCPlus4M),
        .RdM(RdM),
        .ResultSrcW(ResultSrcW),
        .RdW(RdW),
        .ResultW(ResultW)
    );

    // Gera clock
    always #5 clock = ~clock;

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, write_back_tb);
        // Inicializa os sinais
        clock = 0;
        reset = 1;
        ALUResultM = 0;
        ReadDataM = 0;
        PCPlus4M = 0;
        RdM = 0;
        ResultSrcW = 0;

        // Solta o reset
        #10 reset = 0;

        // Testa o comportamento do registrador
        #10 ALUResultM = 64'hAABBCCDDEEFF0011;
            ReadDataM = 64'h123456789ABCDEF0;
            PCPlus4M = 64'h0000000000000044;
            RdM = 5'b10101;

        // Espera para capturar os dados no flopr
        #10;

        // Testa o mux com diferentes seleções
        #10 ResultSrcW = 2'b00; // Seleciona AluResultW
        #10 $display("Mux Output (ALU Result): %h", ResultW);

        #10 ResultSrcW = 2'b01; // Seleciona ReadDataW
        #10 $display("Mux Output (Read Data): %h", ResultW);

        #10 ResultSrcW = 2'b10; // Seleciona PCPlus4W
        #10 $display("Mux Output (PCPlus4): %h", ResultW);

        // Finaliza a simulação
        #50 $finish;
    end

endmodule
