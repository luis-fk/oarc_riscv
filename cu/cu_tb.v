`timescale 1ns / 1ps

module cu_tb;

    // Inputs
    reg clock;
    reg reset;

    reg [6:0] opD;
    reg [2:0] funct3D;
    reg funct7b5D;
    reg FlushE;
    reg ZeroE;

    // Outputs
    wire [1:0] ImmSrcD;
    wire PCSrcE;
    wire [2:0] ALUControlE;
    wire ALUSrcBE;
    wire ResultSrcEb0;
    wire MemWriteM;
    wire RegWriteM;
    wire RegWriteW;
    wire [1:0] ResultSrcW;

    // Instantiate the Unit Under Test (UUT)
    cu uut (
        .clock(clock),
        .reset(reset),
        .opD(opD),
        .funct3D(funct3D),
        .funct7b5D(funct7b5D),
        .ImmSrcD(ImmSrcD),
        .FlushE(FlushE),
        .ZeroE(ZeroE),
        .PCSrcE(PCSrcE),
        .ALUControlE(ALUControlE),
        .ALUSrcBE(ALUSrcBE),
        .ResultSrcEb0(ResultSrcEb0),
        .MemWriteM(MemWriteM),
        .RegWriteM(RegWriteM),
        .RegWriteW(RegWriteW),
        .ResultSrcW(ResultSrcW)
    );

    // Clock Generation
    initial begin
        clock = 0;
        forever #5 clock = ~clock; // 10ns clock period
    end

    // Test Sequence
    initial begin
        // Initialize inputs
       $dumpfile("wave.vcd");
        $dumpvars(0, cu_tb);
        reset = 1;
        opD = 7'b0;
        funct3D = 3'b0;
        funct7b5D = 0;
        FlushE = 0;
        ZeroE = 0;

        // Hold reset for a few clock cycles
        #15 reset = 0;

        // Test Case 1: Add
        opD = 7'b0110011;  // Example R-type opcode
        funct3D = 3'b000;  // Example funct3 for ADD
        funct7b5D = 1'b0;  // Example funct7 bit 5
        FlushE = 1'b0;
        ZeroE = 1'b0;
        #20;

        // Test Case 2: sub
        funct7b5D = 1'b1;
        #20;

        // Test Case 3: or
        funct3D = 3'b110; 
        #20;

        // Test Case 4: and
        funct3D = 3'b111; 
        #20;

        // Test Case 5: lw
        opD = 7'b0000011;
        #20;

        // Test Case 6: sw
        opD = 7'b0100011;
        #20;

        // Test Case 7: beq
        opD = 7'b1100011;
        #20;

        // End simulation
        $finish;
    end

endmodule
