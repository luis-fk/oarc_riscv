`timescale 1ns / 1ns

module pipelined_riscv_tb();    
    reg clock;
    reg reset_pc;

    pipelined_riscv uut (
        .clock(clock),
        .reset_pc(reset_pc)
    );    

    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end
    
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(5, pipelined_riscv_tb);
        reset_pc = 1;
        #100
        reset_pc = 0;
    
        #2000
        $finish;
    end
endmodule