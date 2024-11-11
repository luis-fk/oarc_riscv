module execute (
    input clock,

    /* inputs da UC */
    input reg_write_d,
    input [1:0] result_src_d,
    input mem_write_d,
    input jump,
    input branch,
    input [3:0] alu_control,
    input alu_src,

    /* inputs do decode */
    input [63:0] read_data1,
    input [63:0] read_data2,
    input [63:0] pc,
    input [4:0]  destination_register_d,
    input [63:0] immediate_extended,
    input [63:0] pc_plus4_d,

    /* outputs */
    output pc_source,
    output [63:0] pc_target,
    output reg reg_write_e,
    output reg [1:0] result_src_e,
    output reg mem_write_e,
    output reg [63:0] alu_result,
    output reg [63:0] write_data,
    output reg [4:0] destination_register_e,
    output reg [63:0] pc_plus4_e
);
    wire [63:0] src_b;
    wire [63:0] alu_out;
    wire zero;
    wire and_out;

    ALU ALU (.A(read_data1), .B(src_b), .ALUOp(alu_control), .result(alu_out), .equal(), 
             .not_equal(), .lesser_than(), .greater_or_equal(), .unsigned_lesser(), 
             .unsigned_greater_equal());

    and (and_out, zero, branch);

    or (pc_source, and_out, jump);

    assign src_b = alu_src ? immediate_extended : read_data2;

    assign pc_target = pc + immediate_extended;

    assign zero = alu_out == 64'b0;

    always @(posedge clock) begin
        reg_write_e <= reg_write_d;
        result_src_e <= result_src_d;
        mem_write_e <= mem_write_d;
        write_data <= read_data2;
        destination_register_e <= destination_register_d;
        pc_plus4_e <= pc_plus4_d;
        alu_result <= alu_out;
    end
endmodule