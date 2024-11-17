module mux2 #(parameter WIDTH = 8) (
    input [WIDTH-1:0] d0, d1,
    input s,
    output [WIDTH-1:0] y
);
assign y = s ? d1 : d0;  //se s = 1, y = d1
                         //se s = 0, y = d0
  
endmodule
