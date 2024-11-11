module fetch_tb;
    // Testbench signals
    reg branch;
    reg clock;
    reg reset_pc;
    reg [63:0] pc_target;
    wire [31:0] instruction;
    wire [63:0] pc_current_instruction;
    wire [63:0] pc_next_instruction;

    // Instantiate the fetch module
    fetch uut (
        .reset_pc(reset_pc),
        .branch(branch),
        .clock(clock),
        .pc_target(pc_target),
        .instruction(instruction),
        .pc_current_instruction(pc_current_instruction),
        .pc_next_instruction(pc_next_instruction)
    );

    // Clock generation
    initial begin
        clock = 0;
        forever #5 clock = ~clock; // 10 time units period
    end

    // Function to verify the output
    task verify_output;
        input [63:0] expected_instruction;
        begin
            #10; // Wait for a full clock cycle to read the output
            if (instruction !== expected_instruction) begin
                $display("Test failed: instruction = %0d, expected = %0d", instruction, expected_instruction);
            end else begin
                $display("Test passed: instruction = %0d", instruction);
            end
        end
    endtask

    // Test sequence
    initial begin
        // Initialize inputs
        branch = 0;
        pc_target = 64'd0;
        reset_pc = 1'b1;

        // Apply reset
        #20;  // Wait for a couple of cycles for reset
        reset_pc = 1'b0; // Release reset

        // Test case 1: No branch, expect instruction at address 0
        branch = 0;
        pc_target = 64'd0;
        verify_output(64'd1); // Expect first memory instruction value
        
        // Test case 2: Branch to a specific target address
        branch = 1;
        pc_target = 64'd20;
        #10
        branch = 0;
        verify_output(64'd20); // Verify branch target instruction

        // Test case 3: No branch, expect to continue incrementing
        verify_output(64'd21); // Expect instruction after branch target
        
        // Test case 4: No branch, continuous increment
        verify_output(64'd22);

        // Finish simulation
        $stop;
    end
endmodule
