module fetch (
    input branch,
    input clock,
    input reset_pc,
    input [63:0] pc_target,
    output reg [31:0] instruction,
    output reg [63:0] pc_current_instruction,
    output reg [63:0] pc_next_instruction
);
    wire [31:0] read_data;
    wire [63:0] program_counter_mux;
    wire [63:0] next_instruction_wire;

    reg [63:0] program_counter;

    assign program_counter_mux = (branch == 1'b1) ? pc_target : next_instruction_wire;
    assign next_instruction_wire = program_counter + 64'd1;
    
    instructions_memory inst_mem (
        .address(program_counter[10:0]),
        .read_data(read_data)
    );

    always @(posedge clock) begin
        case (reset_pc)
            1'b1:  program_counter <= 64'd0;
            default: program_counter <= program_counter_mux;
        endcase
        instruction <= read_data;
        pc_current_instruction <= program_counter;
        pc_next_instruction <= next_instruction_wire;
    end
endmodule
