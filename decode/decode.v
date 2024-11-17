module decode (
    input clock,
    input reset,
    input [31:0] InstrF,      //InstrF
    input [63:0] PCF, // PCF
    input [63:0] PCPlus4F,    // PCPlus4F
    input [1:0]  ImmSrcD, // n utilizado pelo imm_gen
    input [63:0] ResultW,         //ResultW
    input [4:0] reg_to_write_src,         //A3
    input WriteEnable,

    //inputs da Unidade Hazard
    input FlushD,
    input StallD,

    // uc
    output wire [6:0] opcode,
    output wire [2:0] func3,
    output wire [6:0] func7,

    // banco de registradores
    output [63:0] read_data1,                    //RD1
    output [63:0] read_data2,                    //RD2
    output [63:0] PCD,                           //PCD
    output [4:0] Rs1D,                       //Rs1D
    output [4:0] Rs2D,                       //Rs2D
    output [4:0] RdD,                //RdD
    output [63:0] ImmExtD,                  //ImmExtD
    output [63:0] PCPlus4D      //PCPlus4D
);

    wire [31:0] InstrD;
    wire [63:0] PCD;
    wire [63:0] PCPlus4D;

    //Antigo
    //assign reg1_src_wire = current_instruction[19:15];
    //assign reg2_src_wire = current_instruction[24:20];
    //assign reg_destiny_src_wire = current_instruction[11:7];

    // to uc
    
    //Antigo
    //assign opcode = current_instruction[6:0];
    //assign func3 = current_instruction[14:12];
    //assign func7 = current_instruction[31:25];

    //Novo

    assign Rs1D = InstrD[19:15];
    assign Rs2D = InstrD[24:20];
    assign RdD = InstrD[11:7];

    //to uc

    assign opcode = InstrD[6:0];
    assign func3 = InstrD[14:12];
    assign func7 = InstrD[31:25];


    flopenrc #(
        .WIDTH(160)
        )
        regD (
            .clk(clock),
            .reset(reset), 
            .clear(FlushD),
            .en(~StallD),
            .d({InstrF, PCF, PCPlus4F}), //{InstrF,PCF,PCPlus4F}
            .q({InstrD, PCD, PCPlus4D})
        );

    BancoRegistradores #(
        .BITS(64) 
        ) 
        RegisterFile (
            .clk              (clock),
            .Ra               (Rs1D),             
            .Rb               (Rs2D),
            .Rw               (reg_to_write_src),
            .We               (WriteEnable),
            .din              (ResultW),
            .douta            (read_data1),
            .doutb            (read_data2)
        );


    // RegisterFile register_file(
    //     .readRegister1 (Rs1D),
    //     .readRegister2 (Rs2D),
    //     .writeRegister (reg_to_write_src),
    //     .writeData     (ResultW), 
    //     .regWrite      (WriteEnable),        //Write Enable (RegWriteW)
    //     .clk           (clock),
    //     .readData1     (read_data1),
    //     .readData2     (read_data2)
    // );

    ExtendImm ExtendMatheus (
        .instr(InstrD),
        .immsrc(ImmSrcD),
        .immext(ImmExtD)
    );

    // immediateG imm_gen(
    //     //.instruction(current_instruction),
    //     .instruction(InstrD),
    //     .immediate  (ImmExtD)
    // );

endmodule