module pipelined_riscv(
    input clock,
    input reset_pc
);
    wire [1:0] imm_src;
    wire [1:0] result_src;
    wire mem_write;
    wire [3:0] alu_control_id;
    wire alu_src;
    wire jump;

    wire [6:0] opcode;
    wire [2:0] func3;
    wire [6:0] func7;
    wire [4:0] reg_to_write_src;
    wire reg_write;
    wire branch;

    pipelined_riscv_fd fd (
        .clock           (clock),
        .reset_pc        (reset_pc),
        // input uc
        .reg_to_write_src(),
        .reg_write       (reg_write),
        .result_src      (result_src),
        .mem_write       (mem_write),
        .jump            (jump), 
        .branch          (branch),
        .alu_control_id  (alu_control_id),
        .alu_src         (alu_src),
        .imm_src         (imm_src),
        // outputs
        .opcode          (opcode),
        .func3           (func3),
        .func7           (func7)
    );

    cu cu (
        .op         (opcode),
        .funct3     (func3),
        .funct7b5   (func7[4]),
        .Zero       (), // em aberto
        .ResultSrc  (result_src),
        .MemWrite   (mem_write),
        .PCSrc      (), // em aberto
        .ALUSrc     (alu_src),
        .RegWrite   (reg_write),
        .Jump       (jump), 
        .ImmSrc     (imm_src),
        .ALUControl (alu_control_id),
        .Branch     (branch)
    );
endmodule