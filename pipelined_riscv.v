module pipelined_riscv(
    input clock,
    input reset_pc
);

    //Entre UC e FD
    wire s_PCSrcE;
    wire [1:0] s_ImmSrcD;
    wire s_ALUSrcE;
    wire [2:0] s_ALUControlE;
    wire s_MemWriteM;
    wire s_ResultSrcW;

    wire [6:0] s_opcode;
    wire [2:0] s_func3;
    wire [6:0] s_func7;
    wire s_zeroE;


    //Entre FD e Hazard 
    wire s_StallF;
    wire s_StallD;
    wire s_FlushD;
    wire s_FlushE; //Vai pra UC também
    wire [1:0] s_ForwardAE;
    wire [1:0] s_ForwardBE;

    wire [4:0] s_Rs1D;
    wire [4:0] s_Rs2D;
    wire [4:0] s_Rs1E;
    wire [4:0] s_Rs2E;
    wire [4:0] s_RdE;
    wire [4:0] s_RdM;
    wire [4:0] s_RsW;

    //Entre UC e Hazard
    wire s_ResultSrcEb0;
    wire s_RegWriteM;
    wire s_RegWriteW; //Vai pra FD também

    wire [4:0] s_RdW;

    pipelined_riscv_fd fd (
        .clock           (clock),
        .reset_pc        (reset_pc),

        // input uc
            //Fetch:
        .PCSrcE          (s_PCSrcE),

            //Decode: 
        .ImmSrcD         (s_ImmSrcD),
        .RegWriteW       (s_RegWriteW),

            //Execute:
        .ALUSrcE         (s_ALUSrcE),
        .ALUControlE     (s_ALUControlE),

            //Memory:  
        .MemWriteM       (s_MemWriteM),

            //WriteBack:
        .ResultSrcW      (s_ResultSrcW),

        //Inputs do Hazard
            //Fetch:
        .StallF           (s_StallF),

            //Decode:
        .StallD          (s_StallD),
        .FlushD          (s_FlushD),

            //Execute:
        .FlushE          (s_FlushE),
        .ForwardAE       (s_ForwardAE),
        .ForwardBE       (s_ForwardBE),

        //Outputs para a UC:
        .opcode          (s_opcode),
        .func3           (s_func3),
        .func7           (s_func7),
        .zeroE           (s_zeroE),

        //Outputs para Hazard Unit

            //Decode:
        .Rs1D            (s_Rs1D),
        .Rs2D            (s_Rs2D),

            //Execute:
        .Rs1E            (s_Rs1E),
        .Rs2E            (s_Rs2E),
        .RdE             (s_RdE),

            //Memory:
        .RdM             (s_RdM),

            //Writeback:
        .RdW             (s_RdW)
    );

    cu cu (
        .clock       (clock),
        .reset       (reset_pc),
        .opD         (s_opcode),
        .funct3D     (s_func3),
        .funct7b5D   (s_func7[5]),
        .ImmSrcD     (s_ImmSrcD),

        .FlushE      (s_FlushE),
        .ZeroE       (s_zeroE),
        .PCSrcE      (s_PCSrcE), 

        .ALUControlE (s_ALUControlE),
        .ALUSrcBE    (s_ALUSrcE),
        .ResultSrcEb0  (s_ResultSrcEb0),
        

        .MemWriteM   (s_MemWriteM),
        .RegWriteM   (s_RegWriteM),

        .RegWriteW   (s_RegWriteW),
        .ResultSrcW  (s_ResultSrcW)
    );

    hazard hu (
        .Rs1D(s_Rs1D),
        .Rs2D(s_Rs2D),
        .Rs1E(s_Rs1E),
        .Rs2E(s_Rs2E),
        .RdE(s_RdE),
        .RdM(s_RdM),
        .RdW(s_RdW),
        .PCSrcE(s_PCSrcE),
        .ResultSrcEb0(s_ResultSrcEb0),
        .RegWriteM(s_RegWriteM),
        .RegWriteW(s_RegWriteW),
        .ForwardAE(s_ForwardAE),
        .ForwardBE(s_ForwardBE),
        .StallF(s_StallF),
        .StallD(s_StallD),
        .FlushD(s_FlushD),
        .FlushE(s_FlushE)
    );


endmodule