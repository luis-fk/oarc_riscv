`timescale  1ps/1ps

module decode_tb;
    // Inputs
    reg clock;
    reg [31:0] current_instruction;
    reg [63:0] addr_current_instruction;
    reg [63:0] addr_next_instruction;
    reg [1:0] imm_src;
    reg [63:0] result_to_write;
    reg [4:0] reg_to_write_src;
    reg reg_write;
    reg [1:0] result_src;
    reg mem_write;
    reg jump;
    reg branch;
    reg [3:0] alu_control_id;
    reg alu_src;

    // Outputs
    wire [6:0] opcode;
    wire [2:0] func3;
    wire [6:0] func7;
    wire reg_write_dec;
    wire [1:0] result_src_dec;
    wire mem_write_dec;
    wire jump_dec;
    wire branch_dec;
    wire [3:0] alu_control_id_dec;
    wire alu_src_dec;
    wire [63:0] read_data1;
    wire [63:0] read_data2;
    wire [63:0] addr_current_instruction_dec;
    wire [4:0] reg1_src;
    wire [4:0] reg2_src;
    wire [4:0] reg_destiny_src;
    wire [63:0] imm_extended;
    wire [63:0] addr_next_instruction_dec;

    // Instantiate the decode module
    decode uut (
        .clock                          (clock),
        .current_instruction            (current_instruction),
        .addr_current_instruction       (addr_current_instruction),
        .addr_next_instruction          (addr_next_instruction),
        .imm_src                        (imm_src),
        .result_to_write                (result_to_write),
        .reg_to_write_src               (reg_to_write_src),
        .reg_write                      (reg_write),
        .result_src                     (result_src),
        .mem_write                      (mem_write),
        .jump                           (jump),
        .branch                         (branch),
        .alu_control_id                 (alu_control_id),
        .alu_src                        (alu_src),
        // outputs
        .opcode                         (opcode),
        .func3                          (func3),
        .func7                          (func7),
        .reg_write_dec                  (reg_write_dec),
        .result_src_dec                 (result_src_dec),
        .mem_write_dec                  (mem_write_dec),
        .jump_dec                       (jump_dec),
        .branch_dec                     (branch_dec),
        .alu_control_id_dec             (alu_control_id_dec),
        .alu_src_dec                    (alu_src_dec),
        .read_data1                     (read_data1),
        .read_data2                     (read_data2),
        .addr_current_instruction_dec   (addr_current_instruction_dec),
        .reg1_src                       (reg1_src),
        .reg2_src                       (reg2_src),
        .reg_destiny_src                (reg_destiny_src),
        .imm_extended                   (imm_extended),
        .addr_next_instruction_dec      (addr_next_instruction_dec)
    );

    // Generate the clock signal
    initial begin
        clock = 0;
        forever #5 clock = ~clock; // 10 time units period
    end

    // Test procedure
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(8, decode_tb);

        // Initialize inputs
        clock = 0;
        current_instruction = 32'h00000000;
        addr_current_instruction = 64'h0000000000000000;
        addr_next_instruction = 64'h0000000000000001;
        imm_src = 2'b00;
        result_to_write = 64'h0000000000000000;
        reg_to_write_src = 5'b00000;
        reg_write = 0;
        result_src = 2'b00;
        mem_write = 0;
        jump = 0;
        branch = 0;
        alu_control_id = 4'b0;
        alu_src = 0;

        // Wait for the reset period
        #20;

        // Test case 1: Set a sample instruction with register and immediate values
        current_instruction = 32'h00a00513; // Example instruction (addi x10, x0, 10)
        addr_current_instruction = 64'h0000000000000000;
        addr_next_instruction = 64'h0000000000000004;
        imm_src = 2'b01; // Not used by imm_gen directly, placeholder
        result_to_write = 64'h00000000000000FF;
        reg_to_write_src = 5'b01010; // x10
        reg_write = 1;
        result_src = 2'b01;
        mem_write = 0;
        jump = 0;
        branch = 0;
        alu_control_id = 4'b0010;
        alu_src = 1;

        #20; // Wait for changes to propagate

        // Check outputs
        $display("Test case 1");
        $display("Opcode: %b", opcode);
        $display("Func3: %b", func3);
        $display("Func7: %b", func7);
        $display("Reg1_src: %d, Reg2_src: %d, Reg_destiny_src: %d", reg1_src, reg2_src, reg_destiny_src);
        $display("Read_data1: %h, Read_data2: %h", read_data1, read_data2);
        $display("Immediate: %h", imm_extended);

        // Test case 2: Another instruction, jump and branch enabled
        current_instruction = 32'h00a00513;
        reg_write = 0;
        mem_write = 1;
        jump = 1;
        branch = 1;
        
        #10;

        // Check outputs
        $display("Test case 2");
        $display("Opcode: %b", opcode);
        $display("Func3: %b", func3);
        $display("Func7: %b", func7);
        $display("Jump_dec: %b, Branch_dec: %b", jump_dec, branch_dec);
        
        $finish; // End of simulation
    end
endmodule
