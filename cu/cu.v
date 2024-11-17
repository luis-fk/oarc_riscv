module cu (
    input clock,
    input reset,

    // Decode Stage:
    input [6:0] opD,
    input [2:0] funct3D,
    input funct7b5D,
    output [1:0] ImmSrcD,

    // Execute Stage
    input FlushE,
    input ZeroE,
    output PCSrcE //FD e Hazard

    output [3:0] ALUControlE,
    output ALUSrcBE,
    output [1:0] ResultSrcEb0,  //Hazard

    // Memory stage

    output MemWriteM,
    output RegWriteM, 
    
    //WriteBack
    output RegWriteW,
    output ResultSrcW  //FD e Hazard
);

    wire [2:0] ALUControlWire;


    wire RegWriteD, RegWriteE;

    wire [1:0] ResultSrcD, ResultSrcE, ResultSrcM;

    wire MemWriteD, MemWriteE;

    wire JumpD, JumpE;

    wire BranchD, BranchE;

    wire [1:0] ALUOpD;

    wire [2:0] ALUControlD;

    wire ALUSrcBD;

    maindec md(
        .op(opD), 
        .ResultSrc(ResultSrcD), 
        .MemWrite(MemWriteD), 
        .Branch(BranchD), 
        .ALUSrc(ALUSrcBD), 
        .RegWrite(RegWriteD), 
        .Jump(JumpD), 
        .ImmSrc(ImmSrcD), 
        .ALUOp(ALUOpD)
    );

    aludec ad(
        .opb5(opD[5]), 
        .funct3(funct3D), 
        .funct7b5(funct7b5D), 
        .ALUOp(ALUOpD), 
        .ALUControl(ALUControlWire)
    );

    floprc #(
        .WIDTH(335)
    ) controlregE (
        .clk(clock),
        .reset(reset),
        .clear(FlushE),
        .d({RegWriteD, ResultSrcD, MemWriteD, JumpD,
            BranchD, ALUControlD, ALUSrcBD}),

        .q({RegWriteE, ResultSrcE, MemWriteE, JumpE,
            BranchE, ALUControlE, ALUSrcBE});
    );

    flopr #(
            .WIDTH() 
    ) controlregM (
            .clk(), 
            .reset(),
            .d({RegWriteE, ResultSrcE, MemWriteE}),
            .q({RegWriteM, ResultSrcM, MemWriteM});
    );

    flopr #(
            .WIDTH(2) 
    ) controlregW (
            .clk(), 
            .reset(),
            .d({RegWriteM, ResultSrcM}),
            .q({RegWriteW, ResultSrcW});
    );

    assign ALUControlE = {1'b0, ALUControlWire};
    assign ResultSrcEb0 = ResultSrcE[0];
    assign PCSrc = BranchE & (ZeroE | JumpE);

endmodule