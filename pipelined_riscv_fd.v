module pipelined_riscv_fd (
    input clock,
    input reset_pc,
    // input control_signals
    input [4:0]reg_to_write_src,
    input reg_write,
    input [1:0] result_src,
    input mem_write,
    input jump,
    input branch,
    input [3:0] alu_control_id,
    input alu_src,
    input [1:0] imm_src,

    // output signals_to_control
    output [6:0] opcode,
    output [2:0] func3,
    output [6:0] func7
);
    wire [31:0] instruction_fetch;
    wire [63:0] pc_current_instruction_fetch;
    wire [63:0] pc_next_instruction_fetch;
    wire [63:0] result_to_write;
    wire [4:0] reg_to_write_src;
    
    /* wire entre execute e fetch */
    wire [63:0] pc_target_execute;
    wire pc_source_execute;

    /* wiress entre decode e execute */
    wire reg_write_decode;
    wire [1:0] result_src_decode;
    wire mem_write_decode;
    wire jump_decode;
    wire branch_decode;
    wire [3:0] alu_control_decode;
    wire alu_src_decode;
    wire [63:0] read_data1_decode;
    wire [63:0] read_data2_decode;
    wire [63:0] pc_current_instruction_decode;
    wire [63:0] pc_next_instruction_decode;
    wire [63:0] imm_extended_decode;
    wire [4:0] reg_destination_src_decode;

    /* wires antre execute e memory */
    wire [63:0] alu_result_execute;
    wire [63:0] write_data_execute;
    wire [4:0] destination_register_execute;
    wire reg_write_execute;
    wire [1:0] result_src_execute;
    wire mem_write_execute;
    wire [63:0] pc_plus4_execute;

    /* wires antre memory e write_back */
    wire [63:0] alu_result_memory;
    wire [4:0] destination_register_memory;
    wire [63:0] next_instruction_memory;
    wire reg_write_memory;
    wire [1:0] result_src_memory;
    wire [63:0] read_data_memory;

    fetch f (
      .branch                (pc_source_execute),
      .clock                 (clock),
      .reset_pc              (reset_pc),
      .pc_target             (pc_target_execute),
      // outputs
      .instruction           (instruction_fetch),
      .pc_current_instruction(pc_current_instruction_fetch),
      .pc_next_instruction   (pc_next_instruction_fetch)
    );

    decode d (
      .clock                        (clock),
      .current_instruction          (instruction_fetch),
      .addr_current_instruction     (pc_current_instruction_fetch),
      .addr_next_instruction        (pc_next_instruction_fetch),
      .imm_src                      (imm_src), // n utilizado pelo imm_gen
      .result_to_write              (result_to_write),
      .reg_to_write_src             (reg_to_write_src),
      .reg_write_memory             (reg_write_memory),
      .reg_write_uc                 (reg_write),
      .result_src                   (result_src),
      .mem_write                    (mem_write),
      .jump                         (jump),
      .branch                       (branch),
      .alu_control_id               (alu_control_id),
      .alu_src                      (alu_src),
      // outputs
      // uc
      .opcode                       (opcode),
      .func3                        (func3),
      .func7                        (func7),

      // banco de registradores
      .reg_write_dec                (reg_write_decode),
      .result_src_dec               (result_src_decode),
      .mem_write_dec                (mem_write_decode),
      .jump_dec                     (jump_decode),
      .branch_dec                   (branch_decode),
      .alu_control_id_dec           (alu_control_decode),
      .alu_src_dec                  (alu_src_decode),
      .read_data1                   (read_data1_decode),
      .read_data2                   (read_data2_decode),
      .addr_current_instruction_dec (pc_current_instruction_decode),
      .reg1_src                     (),
      .reg2_src                     (),
      .reg_destiny_src              (reg_destination_src_decode),
      .imm_extended                 (imm_extended_decode),
      .addr_next_instruction_dec    (pc_next_instruction_decode)
    );

    execute e (
    .clock (clock),
    
    /* inputs da UC */
    .reg_write_d  (reg_write_decode),
    .result_src_d (result_src_decode),
    .mem_write_d  (mem_write_decode),
    .jump         (jump_decode),
    .branch       (branch_decode),
    .alu_control  (alu_control_decode),
    .alu_src      (alu_src_decode),

    /* inputs do decode */
    .read_data1             (read_data1_decode),
    .read_data2             (read_data2_decode),
    .pc                     (pc_current_instruction_decode),
    .destination_register_d (reg_destination_src_decode),
    .immediate_extended     (imm_extended_decode),
    .pc_plus4_d             (pc_next_instruction_decode),

    /* outputs */
    .pc_source              (pc_source_execute),
    .pc_target              (pc_target_execute),
    .reg_write_e            (reg_write_execute),
    .result_src_e           (result_src_execute),
    .mem_write_e            (mem_write_execute),
    .alu_result             (alu_result_execute),
    .write_data             (write_data_execute),
    .destination_register_e (destination_register_execute),
    .pc_plus4_e             (pc_plus4_execute)
);

  memory m (
    .clock              (clock),
    .alu_result_m       (alu_result_execute),
    .write_data_m       (write_data_execute),
    .rd_m               (destination_register_execute),
    .next_instruction_m (pc_plus4_execute),
    .mem_write          (mem_write_execute),

    .reg_write_m        (reg_write_execute),
    .result_src_m       (result_src_execute),
    // outputs
    .alu_result         (alu_result_memory),
    .rd                 (destination_register_memory),
    .next_instruction   (next_instruction_memory),
    .mem_data           (read_data_memory),
    .reg_write          (reg_write_memory),
    .result_src         (result_src_memory)
  );

  write_back wb (
    .alu_result_w       (alu_result_memory),
    .mem_data_w         (read_data_memory),
    .next_instruction_w (next_instruction_memory),
    .result_src         (result_src_memory),
    .rd_w               (destination_register_memory),
    // outputs
    .result_write_back  (result_to_write),
    .rd                 (reg_to_write_src)
  );

endmodule