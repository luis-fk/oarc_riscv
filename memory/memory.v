
module memory (
    input clock,
    input [63:0] alu_result_m,
    input [63:0] write_data_m,
    input [4:0] rd_m,
    input [63:0] next_instruction_m,
    input mem_write,

    input reg_write_m,
    input [1:0] result_src_m,
    
    output reg [63:0] alu_result,
    output reg [4:0] rd,
    output reg [63:0] next_instruction,
    output reg [63:0] mem_data,
    output reg reg_write,
    output reg [1:0] result_src
);
    wire [63:0] mem_data_wire;

    data_memory data_mem (
        .clk(clock),
        .mem_read(1'b1),
        .mem_write(mem_write),
        .endereco(alu_result_m),
        .write_data(write_data_m),

        .read_data(mem_data_wire)
    );

    always @(posedge clock) begin
        alu_result <= alu_result_m;
        rd <= rd_m;
        next_instruction <= next_instruction_m;
        mem_data <= mem_data_wire;
        reg_write <= reg_write_m;
        result_src <= result_src_m;
    end

endmodule