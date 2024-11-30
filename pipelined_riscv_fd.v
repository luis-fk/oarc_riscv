module pipelined_riscv_fd (
    input clock,
    input reset_pc,

    //Inputs da UC

      //Fetch:
    input PCSrcE,

      //Decode:
    input [1:0] ImmSrcD,
    input RegWriteW,

      //Execute:
    input       ALUSrcE,
    input [2:0] ALUControlE,

      //Memory:
    input       MemWriteM,

      //WriteBack
    input [1:0] ResultSrcW,


    //Inputs do Hazard
      //Fetch:
    input StallF,

      //Decode:
    input StallD,
    input FlushD,

      //Execute:
    input FlushE,
    input ForwardAE,
    input ForwardBE,

    // output signals_to_control (Para a UC)
    output [6:0] opcode,
    output [2:0] func3,
    output [6:0] func7,
    output zeroE

    //output Hazard Unit

    //Decode
    output [4:0] Rs1D,
    output [4:0] Rs2D,

    //Execute
    output [4:0] Rs1E,
    output [4:0] Rs2E,
    output [4:0] RdE,

    //Memory
    output [4:0] RdM,

    //WriteBack
    output [4:0] RdW
);

    wire [31:0] instruction_fetch;
    wire [63:0] pc_current_instruction_fetch;
    wire [63:0] pc_next_instruction_fetch;
    
    /* wires entre execute e fetch */
    wire [63:0] pc_target_execute;


    /* wires entre decode e execute */
    wire [63:0] read_data1_decode;
    wire [63:0] read_data2_decode;
    wire [63:0] pc_current_instruction_decode;
    wire [63:0] pc_next_instruction_decode;
    wire [63:0] imm_extended_decode;
    wire [4:0] reg_destination_src_decode;
    wire [4:0] Rs1D_wire,
    wire [4:0] Rs2D_wire,

    /* wires entre execute e memory */
    wire [63:0] alu_result_execute;
    wire [63:0] write_data_execute;
    wire [4:0] destination_register_execute;
    wire [63:0] pc_plus4_execute;

    /* wires entre memory e write_back */
    wire [63:0] ALUResultM_wire;
    wire [4:0] RdM_wire;
    wire [63:0] next_instruction_memory;
    wire [63:0] read_data_memory;

    //Wires entre Memory e o restante do FD
    wire [4:0]  RdW_wire;
    wire [63:0] ResultW_wire;


    

    fetch f (
      //Inputs
      .clock                 (clock),
      .reset_pc              (reset_pc),

        //UC
      .PCSrcE                (PCSrcE),            //Vem da UC (PCSrcE)
      
        //Hazard
      .StallF                (StallF),                        //Unidade Hazard
      
      //Input do Execute
      .pc_target             (pc_target_execute),

      // outputs
      .InstrF                (instruction_fetch),            // InstrF
      .PCF                   (pc_current_instruction_fetch), // PCF
      .PCPlus4F              (pc_next_instruction_fetch)     // PCPlus4F
    );

    decode d (
    //Inputs

      .clock                        (clock),
      .reset                        (reset_pc),
      .InstrF                       (instruction_fetch),             // InstrF
      .PCF                          (pc_current_instruction_fetch),  // PCF
      .PCPlus4F                     (pc_next_instruction_fetch),     // PCPlus4F
      .ImmSrcD                      (immSrcD),                       // n utilizado pelo imm_gen (Deveria vir da UC ImmSrcD)
      .ResultW                      (ResultW_wire),                  // Vem do WriteBack até o WD3
      .reg_to_write_src             (RdW_wire),                      //Recebe lá do WriteBack (A3)
      .WriteEnable                  (RegWriteW),                              //Vem da UC (RegWriteW)                              //Vem da UC
      //.reg_write_uc                 (reg_write),
      //.result_src                   (result_src),
      //.mem_write                    (mem_write),
      //.jump                         (jump),
      //.branch                       (branch),
      //.alu_control_id               (alu_control_id),
      //.alu_src                      (alu_src),

      //inputs da Unidade Hazard

      .FlushD                       (FlushD ),  // Vem da Unidade Hazard
      .StallD                       (StallD ),  // Vem da Unidade Hazard

      // outputs
      // uc
      .opcode                       (opcode),
      .func3                        (func3),
      .func7                        (func7),

      // banco de registradores
      .read_data1                   (read_data1_decode),                //RD1
      .read_data2                   (read_data2_decode),                //RD2
      .PCD                          (pc_current_instruction_decode),    //PCD
      .Rs1D                         (Rs1D_wire),                                 //Rs1D
      .Rs2D                         (Rs2D_wire),                                 //Rs2D
      .RdD                          (reg_destination_src_decode),       //RdD
      .ImmExtD                      (imm_extended_decode),              //ImmExtD
      .PCPlus4D                     (pc_next_instruction_decode)        //PCPlus4D
    );

    execute e (
    .clock (clock),
    .reset (reset_pc),
    
    /* inputs da UC */
    .ALUControlE  (ALUControlE),                // Vem da UC (ALUControlE)
    .ALUSrcE      (ALUSrcE),  // Vem da UC (AluSrcE)

    //Input do Memory
    .ALUResultM(ALUResultM_wire),

    //Input do WriteBack
    .ResultW(ResultW_wire),

    // inputs da Unidade Hazard
    .FlushE(FlushE),
    .ForwardAE(ForwardAE),
    .ForwardBE(ForwardBE),

    /* inputs do decode */
    .read_data1             (read_data1_decode),              //RD1
    .read_data2             (read_data2_decode),              //RD2
    .PCD                    (pc_current_instruction_decode),  //PCD
    .RdD                    (reg_destination_src_decode),     //RdD
    .ImmExtD                (imm_extended_decode),            //ImmExtD
    .PCPlus4D               (pc_next_instruction_decode),     //PCPlus4D
    .Rs1D                   (Rs1D_wire),                      //RsD1
    .Rs2D                   (Rs2D_wire),                      //RsD2

    /* outputs */
    //.pc_source              (pc_source_execute),
    .zeroE                  (zeroE),
    .PCTargetE              (pc_target_execute),              //PCTargetE
    //.reg_write_e            (reg_write_execute),
    //.result_src_e           (result_src_execute),
    //.mem_write_e            (mem_write_execute),
    .ALUResultE             (alu_result_execute),             //ALUResultE
    .WriteDataE             (write_data_execute),             //WriteDataE
    .RdE                    (destination_register_execute),   //Rde
    .PCPlus4E               (pc_plus4_execute),           //PCPlus4E

    //Saída para o Hazard
    .Rs1E                    (Rs1E),
    .Rs2E                    (Rs2E),
    .RdE                     (RdE)

);

  memory m (
    .clock              (clock),
    .reset              (reset_pc),
    .ALUResultE         (alu_result_execute),                 //ALUResultE
    .WriteDataE         (write_data_execute),                 //WriteDataE  
    .RdE                (destination_register_execute),       //RdE
    .PCPlus4E           (pc_plus4_execute),                   //PCPlus4E
    .MemWriteM          (MemWriteM),                          
    //.reg_write_m        (reg_write_execute),
    //.result_src_m       (result_src_execute),


    // outputs
    .RdM                (RdM_wire),        //RdM (Normal)
    .PCPlus4M           (next_instruction_memory),            //PCPlus4M
    .RD_Memory          (read_data_memory),                   //RD do Data Memory
    .ALUResultM         (ALUResultM_wire),                  //ALUResultM

    //.reg_write          (reg_write_memory),
    //.result_src         (result_src_memory)
  );

  write_back wb (
    .clock              (clock),
    .reset              (reset_pc),
    //Inputs do Memory
    .AluResultM         (ALUResultM_wire),
    .ReadDataM          (read_data_memory),
    .PCPlus4M           (next_instruction_memory),
    .RdM                (RdM_wire),

    //Input da ULA
    .ResultSrcW         (ResultSrcW),
    //.result_src         (result_src_memory),
    //.rd_w               (RdM_wire),
    
    // outputs
    .RdW                (RdW_wire),
    .ResultW            (ResultW_wire)

    //.result_write_back  (result_to_write),
    //.rd                 (reg_to_write_src)
  );

  assign Rs1D = Rs1D_wire;
  assign Rs2D = Rs2D_wire;
  assign RdM = RdM_wire;
  assign RdW = RdW_wire;

endmodule