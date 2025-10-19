% --- Cálculo de gorjeta usando Lógica Nebulosa (Octave compatível) ---
pkg load fuzzy-logic-toolkit

% Criação do sistema fuzzy
fis = newfis('gorjeta', 'mamdani');

% Entradas: comida e serviço
fis = addvar(fis, 'input', 'comida', [0 10]);
fis = addmf(fis, 'input', 1, 'ruim', 'trapmf', [-1 0 2 5]);
fis = addmf(fis, 'input', 1, 'media', 'trapmf', [0 5 6 8]);
fis = addmf(fis, 'input', 1, 'boa', 'trapmf', [6 8 10 12]);

fis = addvar(fis, 'input', 'servico', [0 10]);
fis = addmf(fis, 'input', 2, 'ruim', 'trapmf', [-1 0 2 5]);
fis = addmf(fis, 'input', 2, 'medio', 'trapmf', [0 5 6 8]);
fis = addmf(fis, 'input', 2, 'bom', 'trapmf', [6 8 10 12]);

% Saída: gorjeta
fis = addvar(fis, 'output', 'gorjeta', [0 15]);
fis = addmf(fis, 'output', 1, 'baixa', 'trapmf', [-1 0 5 8]);
fis = addmf(fis, 'output', 1, 'media', 'trapmf', [5 8 12 15]);
fis = addmf(fis, 'output', 1, 'alta', 'trapmf', [10 11 14 15]);

% Regras fuzzy
ruleList = [
  1 1 1 1 1;
  2 2 2 1 1;
  3 3 3 1 1;
];
fis = addrule(fis, ruleList);

% Entrada de dados
comida = input("Qualidade da comida (0 a 10): ");
servico = input("Qualidade do serviço (0 a 10): ");

% Avaliação
gorjeta = evalfis([comida servico], fis);
printf("Comida=%.1f | Serviço=%.1f → Gorjeta sugerida: %.2f%%\n", comida, servico, gorjeta);

% --- Geração do gráfico 3D ---
[x, y] = meshgrid(0:1:10, 0:1:10);
z = zeros(size(x));
for i = 1:size(x,1)
  for j = 1:size(x,2)
    z(i,j) = evalfis([x(i,j) y(i,j)], fis);
  end
end

mesh(x, y, z);
xlabel('Comida');
ylabel('Serviço');
zlabel('Gorjeta (%)');
title('Superfície Fuzzy: Gorjeta em função da Comida e do Serviço');

