module cu_tb;

    // Inputs
    reg [6:0] op;
    reg [2:0] funct3;
    reg funct7b5;
    reg Zero;

    // Outputs
    wire [1:0] ResultSrc;
    wire MemWrite;
    wire PCSrc;
    wire ALUSrc;
    wire RegWrite;
    wire Jump;
    wire [1:0] ImmSrc;
    wire [2:0] ALUControl;
    wire Branch;

    // Instantiate the Unit Under Test (UUT)
    cu uut (
        .op(op),
        .funct3(funct3),
        .funct7b5(funct7b5),
        .Zero(Zero),
        .ResultSrc(ResultSrc),
        .MemWrite(MemWrite),
        .PCSrc(PCSrc),
        .ALUSrc(ALUSrc),
        .RegWrite(RegWrite),
        .Jump(Jump),
        .ImmSrc(ImmSrc),
        .ALUControl(ALUControl),
        .Branch(Branch)
    );

    initial begin

        $dumpfile("cu_tb.vcd");
        $dumpvars(0, cu_tb);

        // Initialize Inputs
        Zero = 0;

        // Test 1: R-type instruction (e.g., add)
        op = 7'b0110011; // opcode for R-type
        funct3 = 3'b000;  // funct3 for add
        funct7b5 = 0;     // funct7[5] for add
        #10;

        // Test 2: I-type instruction (e.g., addi)
        op = 7'b0010011; // opcode for I-type
        funct3 = 3'b000;  // funct3 for addi
        funct7b5 = 0;
        #10;

        // Test 3: S-type instruction (e.g., store)
        op = 7'b0100011; // opcode for S-type
        funct3 = 3'b010; // funct3 for SW (store word)
        funct7b5 = 0;
        #10;

        // Test 4: B-type instruction (e.g., branch if equal)
        op = 7'b1100011; // opcode for B-type
        funct3 = 3'b000; // funct3 for BEQ
        funct7b5 = 0;
        Zero = 1;        // Set Zero flag to 1 to simulate branch condition
        #10;

        // Test 5: J-type instruction (e.g., jump)
        op = 7'b1101111; // opcode for JAL
        funct3 = 3'b000;
        funct7b5 = 0;
        #10;

        // Test 6: R-type instruction (e.g., subtract)
        op = 7'b0110011; // opcode for R-type
        funct3 = 3'b000;  // funct3 for subtract
        funct7b5 = 1;     // funct7[5] for subtract
        #10;

        // Finish simulation
        $stop;
    end
endmodule
