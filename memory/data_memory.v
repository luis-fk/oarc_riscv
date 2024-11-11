module data_memory(input clk,      
              input mem_read,
              input mem_write,
              input [63:0] endereco, // Endereço de saída da ULA
              input [63:0] write_data, // Dados a serem escritos
              output [63:0] read_data // Dados a serem lidos
             );
   reg [63:0] endereco_atual;
   reg [7:0] Memory [2047:0];

   /*
    Memoria 64x32
    Neste caso, foi instanciado em bytes, por isso são 2048 posições
   */
   initial begin
     /*
      Initial Data Memory -> Set up expected initial values
     */
     // Initial value at address 0 (for test case 1)
     Memory[0] = 8'd0;
     Memory[1] = 8'd0;
     Memory[2] = 8'd0;
     Memory[3] = 8'd0;
     Memory[4] = 8'd0;
     Memory[5] = 8'd0;
     Memory[6] = 8'd0;
     Memory[7] = 8'd8; // Initial value of 64'd8 at address 0

     // Values at address 10 and 20 will be set during the test cases
     // but initialized here to a known state:
     Memory[8] = 8'd0;
     Memory[9] = 8'd0;
     Memory[10] = 8'd0;
     Memory[11] = 8'd0;
     Memory[12] = 8'd0;
     Memory[13] = 8'd0;
     Memory[14] = 8'd0;
     Memory[15] = 8'd7; // Initial value at address 7

     Memory[16] = 8'd0;
     Memory[17] = 8'd0;
     Memory[18] = 8'd0;
     Memory[19] = 8'd0;
     Memory[20] = 8'd0;
     Memory[21] = 8'd0;
     Memory[22] = 8'd0;
     Memory[23] = 8'd0; // Initial value at address 20
   end
   
   // Concatenate bytes to form 64-bit read data
   assign read_data = {Memory[endereco + 0], Memory[endereco + 1], 
                       Memory[endereco + 2], Memory[endereco + 3],
                       Memory[endereco + 4], Memory[endereco + 5], 
                       Memory[endereco + 6], Memory[endereco + 7]}; 

   // Write data on positive clock edge if mem_write is high
   always @(posedge clk) begin        
        if (mem_write == 1) begin
          Memory[endereco + 7] <= write_data[7:0];
          Memory[endereco + 6] <= write_data[15:8];
          Memory[endereco + 5] <= write_data[23:16];
          Memory[endereco + 4] <= write_data[31:24];
          Memory[endereco + 3] <= write_data[39:32];
          Memory[endereco + 2] <= write_data[47:40];
          Memory[endereco + 1] <= write_data[55:48];
          Memory[endereco] <= write_data[63:56];
        end
   end      
endmodule
