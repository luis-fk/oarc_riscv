module mux3 #(parameter WIDTH = 8) (
    input [WIDTH-1:0] d0, d1, d2,
    input [1:0] s,
    output reg [WIDTH-1:0] y
);
always @(*) begin
    if (s[1])      //s = 10 ou 11
        y = d2;
    else if (s[0]) //s = 01
        y = d1;
    else           //s = 00
        y = d0;
end

endmodule
