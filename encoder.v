module Encoder (
    input  wire clk,
    input  wire rst_n,
    input  wire horario,
    input  wire antihorario,
    output reg  A,
    output reg  B
);

    // Quadrantes em Gray code
    localparam [1:0]
        Q0 = 2'b00,
        Q1 = 2'b10,
        Q2 = 2'b11,
        Q3 = 2'b01;

    // Estado atual e próximo estado
    reg [1:0] direcao, next_direcao;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset inicial
            direcao      <= Q0;
            A            <= 1'b0;
            B            <= 1'b0;
        end else begin
            // Calcula o próximo estado (next_direcao)
            if (horario && !antihorario) begin

                case (direcao)
                    Q0: next_direcao = Q1;
                    Q1: next_direcao = Q2;
                    Q2: next_direcao = Q3;
                    Q3: next_direcao = Q0;
                    default: next_direcao = Q0;
                endcase

            end else if (!horario && antihorario) begin

                case (direcao)
                    Q0: next_direcao = Q3;
                    Q3: next_direcao = Q2;
                    Q2: next_direcao = Q1;
                    Q1: next_direcao = Q0;
                    default: next_direcao = Q0;
                endcase

            end else begin
                // Sem pulso: mantém o mesmo quadrante
                next_direcao = direcao;
            end

            // Atualiza o estado, separa A e B selecionando a posição 1 para e 0 para vindas do reg next_direção
            direcao <= next_direcao;
            A       <= next_direcao[1];
            B       <= next_direcao[0];
        end
    end

endmodule
