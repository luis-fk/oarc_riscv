module fetch (
    input clock,
    input reset_pc,

    //Input UC
    input PCSrcE,

    //Input Hazard
    input StallF,
    
    //Input Execute
    input [63:0] pc_target,

    //Outputs

    output [31:0] InstrF,        //RD do Instruction Memory
    output [63:0] PCF,           //Saída do Reg
    output [63:0] PCPlus4F    

);
    wire [63:0] s_PCF_Linha;     //Saída do Mux
    wire [63:0] s_PCPlus4F;
    wire [63:0] s_PCF;
    
    // MUX para selecionar o próximo valor do PC com base em PCSrcE

    mux2 #(
        .WIDTH(64)
    ) PCinstruc (
        .d0(s_PCPlus4F),
        .d1(pc_target),
        .s(PCSrcE),
        .y(s_PCF_Linha)
    );

    // Flip-flop com enable e reset para o contador do programa
    flopenr #(
            .WIDTH(64)
        ) 
        pcreg
        (
            .clk(clock), 
            .reset(reset_pc), 
            .en(~StallF), 
            .d(s_PCF_Linha), 
            .q(s_PCF)
        );

    // Instância da memória de instruções
    instructions_memory inst_mem (
        .address(s_PCF[10:0]),
        .read_data(InstrF)
    );

    //Somador
    assign s_PCPlus4F = s_PCF + 64'd1;

    assign PCF = s_PCF;
    assign PCPlus4F = s_PCPlus4F;

endmodule
