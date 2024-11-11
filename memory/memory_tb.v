module data_memory_tb;
    // Testbench signals
    reg clk;
    reg mem_read;
    reg mem_write;
    reg [63:0] endereco;
    reg [63:0] write_data;
    wire [63:0] read_data;

    // Instantiate the data_memory module
    data_memory uut (
        .clk(clk),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .endereco(endereco),
        .write_data(write_data),
        .read_data(read_data)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10 time units period
    end

    // Test sequence
    initial begin
        // Initialize inputs
        mem_read = 0;
        mem_write = 0;
        endereco = 0;
        write_data = 64'd0;

        // Test case 1: Read from initial memory
        #10;
        mem_read = 1;
        endereco = 64'd0;
        #10;
        if (read_data !== 64'd8) begin
            $display("Test failed: Initial read, expected = 8, got = %0d", read_data);
        end else begin
            $display("Test passed: Initial read, read_data = %0d", read_data);
        end
        mem_read = 0;

        // Test case 2: Write to memory at address 10
        #10;
        mem_write = 1;
        endereco = 64'd10;
        write_data = 64'd42;
        #10; // Wait for write to complete
        mem_write = 0;

        // Test case 3: Read back from address 10 to verify write
        #10;
        mem_read = 1;
        #10;
        if (read_data !== 64'd42) begin
            $display("Test failed: Write-then-read, expected = 42, got = %0d", read_data);
        end else begin
            $display("Test passed: Write-then-read, read_data = %0d", read_data);
        end
        mem_read = 0;

        // Test case 4: Write to memory at address 20 and read back
        #10;
        mem_write = 1;
        endereco = 64'd20;
        write_data = 64'd100;
        #10;
        mem_write = 0;
        mem_read = 1;
        endereco = 64'd20;
        #10;
        if (read_data !== 64'd100) begin
            $display("Test failed: Second write-then-read, expected = 100, got = %0d", read_data);
        end else begin
            $display("Test passed: Second write-then-read, read_data = %0d", read_data);
        end
        mem_read = 0;

        // Finish simulation
        $stop;
    end
endmodule
