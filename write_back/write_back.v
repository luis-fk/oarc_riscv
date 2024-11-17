module write_back (
    input clock,
    input reset,

    //Input do Memory
    input [63:0] ALUResultM,
    input [63:0] ReadDataM,
    input [63:0] PCPlus4M,
    input [4:0] RdM,

    //Input da ULA
    input [1:0] ResultSrcW,
    
    //Saídas do Memory
    output [4:0]  RdW,
    output [63:0] ResultW
);

    wire [63:0] ALUResultW;
    wire [63:0] ReadDataW;
    wire [63:0] PCPlus4W;


    flopr #(
            .WIDTH(197) 
        ) regM (
            .clk(clock), 
            .reset(reset),
            .d({ALUResultM, ReadDataM, RdM, PCPlus4M}),
            .q({ALUResultW, ReadDataW, RdW, PCPlus4W})
    );

    mux3 #(
            .WIDTH(64) 
        ) resultmux (
            .d0(ALUResultW),
            .d1(ReadDataW),
            .d2(PCPlus4W), 
            .s(ResultSrcW),
            .y(ResultW)
    );

endmodule