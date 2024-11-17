module ULA(
    input [63:0] SrcA,         // Entrada de 64 bits
    input [63:0] SrcB,         // Entrada de 64 bits
    input [2:0] ALUControl,    // Controle da operação (3 bits)
    output reg [63:0] ALUResult, // Resultado da operação (64 bits)
    output ZeroE               // Sinal de igualdade (1 bit)
);

    // Calcula o sinal de igualdade para subtração
    assign ZeroE = (ALUControl == 3'b001 && (SrcA - SrcB) == 64'b0) ? 1'b1 : 1'b0;

    always @(*) begin
        case (ALUControl)
            3'b000: ALUResult = SrcA + SrcB;                      // ADD
            3'b001: ALUResult = SrcA - SrcB;                      // SUBTRACT
            3'b101: ALUResult = (SrcA < SrcB) ? 64'b1 : 64'b0;    // SET LESS THAN
            3'b011: ALUResult = SrcA | SrcB;                      // OR
            3'b010: ALUResult = SrcA & SrcB;                      // AND
            default: ALUResult = 64'b0;                           // Valor padrão
        endcase
    end

endmodule
