module execute_tb();
    reg clock;
    reg reg_write_d;
    reg [1:0] result_src_d;
    reg mem_write_d;
    reg jump;
    reg branch;
    reg [3:0] alu_control;
    reg alu_src;
    reg [63:0] read_data1;
    reg [63:0] read_data2;
    reg [63:0] pc;
    reg [4:0] destination_register_d;
    reg [63:0] immediate_extended;
    reg [63:0] pc_plus4_d;

    wire pc_source;
    wire [63:0] pc_target;
    wire reg_write_e;
    wire [1:0] result_src_e;
    wire mem_write_e;
    wire [63:0] alu_result;
    wire [63:0] write_data;
    wire [4:0] destination_register_e;
    wire [63:0] pc_plus4_e;

    execute uut (
        .clock(clock),
        .reg_write_d(reg_write_d),
        .result_src_d(result_src_d),
        .mem_write_d(mem_write_d),
        .jump(jump),
        .branch(branch),
        .alu_control(alu_control),
        .alu_src(alu_src),
        .read_data1(read_data1),
        .read_data2(read_data2),
        .pc(pc),
        .destination_register_d(destination_register_d),
        .immediate_extended(immediate_extended),
        .pc_plus4_d(pc_plus4_d),
        .pc_source(pc_source),
        .pc_target(pc_target),
        .reg_write_e(reg_write_e),
        .result_src_e(result_src_e),
        .mem_write_e(mem_write_e),
        .alu_result(alu_result),
        .write_data(write_data),
        .destination_register_e(destination_register_e),
        .pc_plus4_e(pc_plus4_e)
    );

    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end
    
    integer i = 1;

    task verify_output;
        input [63:0] expected_alu_result;
        input expected_pc_source;
        input [63:0] expected_write_data;
        begin
            $display("Test %d", i);
            i = i + 1;

            #10; 
            if (alu_result !== expected_alu_result) begin
                $display("ALU Test failed: alu_result = %0h, expected = %0h", alu_result, expected_alu_result);
            end 
            else if (pc_source !== expected_pc_source) begin
                $display("PC Source Test failed: pc_source = %0b, expected = %0b", pc_source, expected_pc_source);
            end
            else if (write_data !== expected_write_data) begin
                $display("Write Data Test failed: write_data = %0h, expected = %0h", write_data, expected_write_data);
            end else begin
                $display("Test %d passed", i);
            end
        end
    endtask

    initial begin
        reg_write_d = 0;
        result_src_d = 2'b00;
        mem_write_d = 0;
        jump = 0;
        branch = 0;
        alu_control = 4'b0000;
        alu_src = 0;
        read_data1 = 64'h0;
        read_data2 = 64'h0;
        pc = 64'h0;
        destination_register_d = 5'b0;
        immediate_extended = 64'h0;
        pc_plus4_d = 64'h4;

        #10;

        // Test 1: ADD 
        reg_write_d = 1;
        alu_control = 4'b0000; 
        read_data1 = 64'h3; 
        read_data2 = 64'h4; 
        destination_register_d = 5'd1;
        #10;
        verify_output(64'h7, 0, read_data2); 

        // Test 2: AND 
        alu_control = 4'b0001;
        read_data1 = 64'hF0F0F0F0F0F0F0F0;
        read_data2 = 64'h0F0F0F0F0F0F0F0F;
        #10;
        verify_output(64'h0, 0, read_data2); 

        // Test 3: OR 
        alu_control = 4'b0010; 
        #10;
        verify_output(64'hFFFFFFFFFFFFFFFF, 0, read_data2); 

        // Test 4: SUB 
        alu_control = 4'b0011; 
        read_data1 = 64'hA;
        read_data2 = 64'h3;
        #10;
        verify_output(64'h7, 0, read_data2); 

        // Test 5: SLT 
        alu_control = 4'b0101;
        read_data1 = 64'h3;
        read_data2 = 64'hA;
        #10;
        verify_output(64'h1, 0, read_data2);

        // Test 6: XOR 
        alu_control = 4'b0100; 
        read_data1 = 64'hF0F0F0F0F0F0F0F0;
        read_data2 = 64'h0F0F0F0F0F0F0F0F;
        #10;
        verify_output(64'hFFFFFFFFFFFFFFFF, 0, read_data2); 

        // Test 7: BEQ 
        alu_src = 0;
        branch = 1;
        alu_control = 4'b0011;
        read_data1 = 64'hA;
        read_data2 = 64'hA; 
        immediate_extended = 64'h4; 
        #10;
        verify_output(64'h0, 1, read_data2); 

        // Test 8: JUMP
        jump = 1;
        branch = 0;
        immediate_extended = 64'h10;
        #10;
        verify_output(alu_result, 1, read_data2); 

        #10;
        $finish;
    end
endmodule
