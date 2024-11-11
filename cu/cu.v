module cu (
    input [6:0] op,
    input [2:0] funct3,
    input funct7b5,
    input Zero,
    output [1:0] ResultSrc,
    output MemWrite,
    output PCSrc, ALUSrc,
    output RegWrite, Jump,
    output [1:0] ImmSrc,
    output [3:0] ALUControl,
    output wire Branch
);

    wire [1:0] ALUOp;

    wire [2:0] ALUControlWire;

    maindec md(op, ResultSrc, MemWrite, Branch, ALUSrc, RegWrite, Jump, ImmSrc, ALUOp);
    aludec ad(op[5], funct3, funct7b5, ALUOp, ALUControlWire);

    assign ALUControl = {1'b0, ALUControlWire};

    // assign PCSrc = Branch & Zero | Jump;
endmodule