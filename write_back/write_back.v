module write_back (
    input [63:0] alu_result_w,
    input [63:0] mem_data_w,
    input [63:0] next_instruction_w,
    input [1:0] result_src,
    input [4:0] rd_w,

    output [63:0] result_write_back,
    output [4:0] rd
);
    assign result_write_back = 
        result_src == 2'd0 ? alu_result_w :
            (result_src == 2'd1 ? mem_data_w : next_instruction_w);
            
    assign rd = rd_w;
endmodule