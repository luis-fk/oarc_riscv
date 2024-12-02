module imem(input logic [31:0] a,
            output logic [31:0] rd);
            logic [31:0] RAM[63:0];
    initial
      $readmemh("/home/usuario/faculdade/oarc/oarc_riscv/top/example.txt", RAM);
      assign rd = RAM[a[31:2]]; // word aligned
endmodule