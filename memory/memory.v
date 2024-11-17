
module memory (
    input clock,
    input reset,
    input [63:0] ALUResultE,              //ALUResultE
    input [63:0] WriteDataE,              //WriteDataE
    input [4:0]  RdE,                       //RdE
    input [63:0] PCPlus4E,        //PCPlus4E
    input MemWriteM,                       //Vem da UC
    //input [1:0] result_src_m,
    
    output [4:0]  RdM,
    output [63:0] PCPlus4M,
    output [63:0] RD_Memory,
    output [63:0] ALUResultM
);

    wire [63:0] WriteDataM;


    flopr #(
            .WIDTH(197) 
        ) regM (
            .clk(clock), 
            .reset(reset),
            .d({ALUResultE, WriteDataE, RdE, PCPlus4E}),
            .q({ALUResultM, WriteDataM, RdM, PCPlus4M})
    );

    data_memory data_mem (
        .clk(clock),
        //.mem_read(1'b1),         // ?????
        .mem_write(MemWriteM),  //Write Enable//
        .endereco(ALUResultM),   //A //
        .write_data(WriteDataM), //WD //
        .read_data(RD_Memory)    //RD do Data Memory
    );


endmodule