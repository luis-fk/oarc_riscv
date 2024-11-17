module Codificador(Rw, We, load);
      input [4:0] Rw;
      input We;
      output [31:0] load;

      genvar i;
      generate
        for (i = 0; i < 32; i = i+1)
        begin
            assign load[i] = We ? Rw==i : 0;
        end
      endgenerate

endmodule