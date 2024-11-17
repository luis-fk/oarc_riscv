module Registrador
 #(parameter BITS = 64) (
  input        clk,
  input        load,
  input  [BITS-1:0] in,
  output [BITS-1:0] out
);

reg [BITS-1:0] data;


always @(posedge clk)
begin
  if (load)
    data <= in;
end

assign out = data;

endmodule