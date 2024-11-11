module decode (
    input clock,
    input [31:0] current_instruction,
    input [63:0] addr_current_instruction,
    input [63:0] addr_next_instruction,
    input [1:0] imm_src, // n utilizado pelo imm_gen
    input [63:0] result_to_write,
    input [4:0] reg_to_write_src,
    input reg_write_memory,
    input reg_write_uc,
    input [1:0] result_src,
    input mem_write,
    input jump,
    input branch,
    input [3:0] alu_control_id,
    input alu_src,

    // uc
    output wire [6:0] opcode,
    output wire [2:0] func3,
    output wire [6:0] func7,

    // banco de registradores
    output reg reg_write_dec,
    output reg [1:0] result_src_dec,
    output reg mem_write_dec,
    output reg jump_dec,
    output reg branch_dec,
    output reg [3:0] alu_control_id_dec,
    output reg alu_src_dec,
    output reg [63:0] read_data1,
    output reg [63:0] read_data2,
    output reg [63:0] addr_current_instruction_dec,
    output reg [4:0] reg1_src,
    output reg [4:0] reg2_src,
    output reg [4:0] reg_destiny_src,
    output reg [63:0] imm_extended,
    output reg [63:0] addr_next_instruction_dec
);

    wire [4:0] reg1_src_wire;
    wire [4:0] reg2_src_wire;
    wire [4:0] reg_destiny_src_wire;
    wire [63:0] read_data_reg1_wire;
    wire [63:0] read_data_reg2_wire;
    wire [63:0] imm_extended_wire;

    assign reg1_src_wire = current_instruction[19:15];
    assign reg2_src_wire = current_instruction[24:20];
    assign reg_destiny_src_wire = current_instruction[11:7];

    // to uc
    assign opcode = current_instruction[6:0];
    assign func3 = current_instruction[14:12];
    assign func7 = current_instruction[31:25];

    RegisterFile register_file(
        .readRegister1 (reg1_src_wire),
        .readRegister2 (reg2_src_wire),
        .writeRegister (reg_to_write_src),
        .writeData     (result_to_write), 
        .regWrite      (reg_write_memory), //enable
        .clk           (clock),
        .readData1     (read_data_reg1_wire),
        .readData2     (read_data_reg2_wire)
    );

    immediateG imm_gen(
        .instruction(current_instruction),
        .immediate  (imm_extended_wire)
    );

    always @(posedge clock) begin
        reg_write_dec <= reg_write_uc;
        result_src_dec <= result_src;
        mem_write_dec <= mem_write;
        jump_dec <= jump;
        branch_dec <= branch;
        alu_control_id_dec <= alu_control_id;
        alu_src_dec <= alu_src;
        read_data1 <= read_data_reg1_wire;
        read_data2 <= read_data_reg2_wire;
        addr_current_instruction_dec <= addr_current_instruction;
        reg1_src <= reg1_src_wire;
        reg2_src <= reg2_src_wire;
        reg_destiny_src <= reg_destiny_src_wire;
        imm_extended <= imm_extended_wire;
        addr_next_instruction_dec <= addr_next_instruction;
    end
endmodule