module execute (
    input clock,
    input reset,

    /* inputs da UC */
    //input reg_write_d,
    //input [1:0] result_src_d,
    //input mem_write_d,
    //input jump,
    //input branch,
    input [2:0] ALUControlE,
    input ALUSrcE,

    // input da saída do pipeline de Memory
    input [63:0] ALUResultM,

    //input da saída do MUX de WriteBack

    input [63:0] ResultW,

    // inputs da Unidade Hazard
    input FlushE,
    input [1:0] ForwardAE,
    input [1:0] ForwardBE,

    /* inputs do decode */
    input [63:0] read_data1,                  //RD1
    input [63:0] read_data2,                  //RD2
    input [63:0] PCD,                         //PCD
    input [4:0]  RdD,                         //RdD
    input [63:0] ImmExtD,                     //ImmExtD
    input [63:0] PCPlus4D,                    //PCPlus4D
    input [4:0]  Rs1D,                        //Rs1D
    input [4:0]  Rs2D,                        //Rs2D

    /* outputs */           
    output zeroE,
    output [63:0] PCTargetE,                  //PCTargetE
    
    output [63:0] ALUResultE,
    output [63:0] WriteDataE,
    output [4:0]  RdE,
    output [63:0] PCPlus4E              //PCPlus4E
);

    wire [63:0] src_b;
    wire and_out;


    //Saída do Registrador Execute Pipeline
    wire [63:0] RD1E;
    wire [63:0] RD2E;
    wire [63:0] PCE;
    wire [4:0]  Rs1E;
    wire [4:0]  Rs2E;
    wire [63:0] ImmExtE;



    wire [63:0] SrcAE_wire;         //Saída do MUX do ForwardAE


    floprc #(
        .WIDTH(335)
    ) regE (
        .clk(clock),
        .reset(reset),
        .clear(FlushE),        
        .d({read_data1,read_data2,PCD,Rs1D,
            Rs2D,RdD,ImmExtD,PCPlus4D}),

        .q({RD1E, RD2E, PCE, Rs1E, Rs2E, RdE, ImmExtE, PCPlus4E})
    );


    // Mux do forwardAE

    mux3 #(
        .WIDTH(64)
    ) faemux (
        .d0(RD1E), 
        .d1(ResultW), 
        .d2(ALUResultM), 
        .s(ForwardAE), 
        .y(SrcAE_wire)
    );

    mux3 #(
        .WIDTH(64)
    ) fbemux (
        .d0(RD2E),
        .d1(ResultW),
        .d2(ALUResultM),
        .s(ForwardBE), 
        .y(WriteDataE)
    );

    mux2 #(
        .WIDTH(64)
    ) srcbmux (
        .d0(WriteDataE),
        .d1(ImmExtE),
        .s(ALUSrcE),
        .y(src_b)
    );

    // ALU ALU (
    //     .A(SrcAE_wire), 
    //     .B(src_b), 
    //     .ALUOp(ALUControlE), 
    //     .result(ALUResultE), 
    //     .equal(zeroE), 
    //     .not_equal(), 
    //     .lesser_than(), 
    //     .greater_or_equal(), 
    //     .unsigned_lesser(), 
    //     .unsigned_greater_equal()
    // );

    ULA ULA(
        .SrcA(SrcAE_wire),
        .SrcB(src_b),
        .ALUControl(ALUControlE),
        .ALUResult(ALUResultE),
        .ZeroE(zeroE)
    );


    //O PC Source não é necessário aqui, a UC já foi feita para receber a flag ZERO_E.
    //Ela quem vai decidir de a próxima instrução será PCTarget ou PCPlus4

    //and (and_out, zero, branch);    //or (pc_source, and_out, jum                     p);


    assign PCTargetE = PCE  + ImmExtD;          

    //assign zero = ALUResultE == 64'b0;


endmodule