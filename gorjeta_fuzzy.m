% --- Cálculo de gorjeta usando Lógica Nebulosa ---
pkg load fuzzy-logic-toolkit

% Criação do sistema fuzzy
fis = newfis('gorjeta_figura1', 'mamdani', 'min', 'max', 'min', 'max', 'centroid');

% --- Funções de Pertinência de Entrada (Comida e Serviço) ---
% Ajustadas para sobreposição e simetria em torno de 5.
fis = addvar(fis, 'input', 'comida', [0 10]);
fis = addmf(fis, 'input', 1, 'ruim',  'trapmf', [-1 0 2 5]);
fis = addmf(fis, 'input', 1, 'media', 'trimf',  [2 5 8]);    % Triângulo Simples centrado em 5
fis = addmf(fis, 'input', 1, 'boa',   'trapmf', [5 8 10 11]);

fis = addvar(fis, 'input', 'servico', [0 10]);
fis = addmf(fis, 'input', 2, 'ruim',  'trapmf', [-1 0 2 5]);
fis = addmf(fis, 'input', 2, 'medio', 'trimf',  [2 5 8]);    % Triângulo Simples centrado em 5
fis = addmf(fis, 'input', 2, 'bom',   'trapmf', [5 8 10 11]);

% --- Funções de Pertinência de Saída (Gorjeta) ---
% Ajustadas para que o centro da MF 'media' seja 10.
fis = addvar(fis, 'output', 'gorjeta', [5 15]);
% Centróide da baixa: aproximadamente 6.25
fis = addmf(fis, 'output', 1, 'baixa', 'trapmf', [4 5 7 8]);
% Centróide da média: exatamente 10 (simétrico: 7.5 a 12.5)
fis = addmf(fis, 'output', 1, 'media', 'trimf',  [7.5 10 12.5]);
% Centróide da alta: aproximadamente 13.75
fis = addmf(fis, 'output', 1, 'alta',  'trapmf', [11 13 15 16]);

% --- Regras Fuzzy (Baseadas na Figura 1) ---
ruleList = [
  % comida  servico  gorjeta  peso  operador
  1 1 1 1 1;  % Ruim e Ruim → Baixa (5%)
  1 2 1 1 1;  % Ruim e Média → Baixa (puxa para 5%)
  2 1 1 1 1;  % Média e Ruim → Baixa (puxa para 5%)

  1 3 2 1 1;  % Ruim e Boa → Média (10%)
  3 1 2 1 1;  % Boa e Ruim → Média (10%)

  2 2 2 1 1;  % Média e Média → Média (10%)

  2 3 3 1 1;  % Média e Boa → Alta (puxa para 15%)
  3 2 3 1 1;  % Boa e Média → Alta (puxa para 15%)
  3 3 3 1 1;  % Boa e Boa → Alta (15%)
];
fis = addrule(fis, ruleList);

% Entrada de dados
comida = input("Qualidade da comida (0 a 10): ");
servico = input("Qualidade do serviço (0 a 10): ");

% Avaliação
gorjeta = evalfis([comida servico], fis);
printf("Comida=%.1f | Serviço=%.1f → Gorjeta sugerida: %.2f%%\n", comida, servico, gorjeta);

% --- Geração do gráfico 3D (Mantém-se sem travamento para suavidade) ---
[x, y] = meshgrid(0:0.5:10, 0:0.5:10);
z = zeros(size(x));
for i = 1:size(x,1)
  for j = 1:size(x,2)
    z(i,j) = evalfis([x(i,j) y(i,j)], fis);
  end
end

figure;
surf(x, y, z);
xlabel('Comida');
ylabel('Serviço');
zlabel('Gorjeta (%)');
title('Superfície Fuzzy: Gorjeta em função da Comida e do Serviço (Fidelidade Figura 1)');

% Ajuste de visualização
zlim([5 15]);
set(gca, 'ztick', [5 7.5 10 12.5 15]);
