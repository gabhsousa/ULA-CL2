module Ula (
    input [5:0] OperandoA,      
    input [5:0] OperandoB,      
    input Reset,                
    input Modo,                 // Sinal de modo (0: aritmético, 1: lógico)
    input [2:0] Operacao,       
    output reg [5:0] Resultado, 
    output reg Overflow,        
    output reg Zero             
);

    always @(*) begin
        Overflow = 1'b0;
        Zero = 1'b0;

        if (Reset) begin
            Resultado = 6'b000000; // Reseta a saída
        end else begin
            case ({Modo, Operacao})
                4'b0000: begin // Soma A + B
                    Resultado = OperandoA + OperandoB;
                    if ({1'b0, OperandoA} + {1'b0, OperandoB} >= 7'b1000000) begin
                        Overflow = 1'b1;
                    end
                end
                4'b0001: begin // Subtração A - B
                    Resultado = OperandoA - OperandoB;
                    if (OperandoA < OperandoB) begin
                        Overflow = 1'b1;
                    end
                end
                4'b0010: begin // Soma A + ~B
                    Resultado = OperandoA + ~OperandoB;
                    if ({1'b0, OperandoA} + {1'b0, ~OperandoB} >= 7'b1000000) begin
                        Overflow = 1'b1;
                    end
                end
                4'b0011: begin // Subtração A - ~B (equivalente a A + B + 1)
                    Resultado = OperandoA + OperandoB + 1;
                    if ({1'b0, OperandoA} + {1'b0, OperandoB} + 1 >= 7'b1000000) begin
                        Overflow = 1'b1;
                    end
                end
                4'b0100: begin // Incremento de A
                    Resultado = OperandoA + 1;
                    if (OperandoA + 1 >= 7'b1000000) begin
                        Overflow = 1'b1;
                    end
                end
                4'b0101: begin // Decremento de A
                    Resultado = OperandoA - 1;
                    if (OperandoA == 6'b000000) begin
                        Overflow = 1'b1;
                    end
                end
                4'b0110: begin // Incremento de B
                    Resultado = OperandoB + 1;
                    if (OperandoB + 1 >= 7'b1000000) begin
                        Overflow = 1'b1;
                    end
                end
                4'b0111: begin // Decremento de B
                    Resultado = OperandoB - 1;
                    if (OperandoB == 6'b000000) begin
                        Overflow = 1'b1;
                    end
                end
                4'b1000: begin // AND lógico
                    Resultado = OperandoA & OperandoB;
                end
                4'b1001: begin // NOT de A
                    Resultado = ~OperandoA;
                end
                4'b1010: begin // NOT de B
                    Resultado = ~OperandoB;
                end
                4'b1011: begin // OR lógico
                    Resultado = OperandoA | OperandoB;
                end
                4'b1100: begin // XOR lógico
                    Resultado = OperandoA ^ OperandoB;
                end
                4'b1101: begin // NAND lógico
                    Resultado = ~(OperandoA & OperandoB);
                end
                4'b1110: begin // Transfere A para a saída
                    Resultado = OperandoA;
                end
                4'b1111: begin // Transfere B para a saída
                    Resultado = OperandoB;
                end
                default: begin // Caso padrão
                    Resultado = 6'b000000;
                end
            endcase
        end
        if (Resultado == 6'b000000) begin
            Zero = 1'b1;
        end else begin
            Zero = 1'b0;
        end
    end
endmodule