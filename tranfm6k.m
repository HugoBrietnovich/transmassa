clc;
clear;

% Parâmetros do problema
F = 0.2;         % Fluxo volumétrico (Mol/m²*s)
Cao = 1;         % Concentração inicial (mol/m³)
RIn = 0.1;       % Raio interno da membrana (m)
Rout = 0.2;      % Raio externo da membrana (m)
delta1 = 8.314;  % Constante termodinâmica (kJ/mol)

% Intervalos para Dam e Ca
Dam_range = linspace(0.00001, 0.00002, 40);  % Intervalo para Dam
Ca_range = linspace(0.5, 0.8, 40);           % Intervalo para Ca

% Função L(Dam, Ca)
L = @(Dam, Ca) (F * (Cao - Ca) .* log(Rout / RIn)) ./ (2 * pi * Dam * Cao * delta1);

% Encontrando o ponto mínimo da função
min_value = inf;
min_Dam = 0;
min_Ca = 0;

for Dam = Dam_range
    for Ca = Ca_range
        current_value = L(Dam, Ca);
        if current_value < min_value
            min_value = current_value;
            min_Dam = Dam;
            min_Ca = Ca;
        end
    end
end

% Encontrando o ponto máximo da função
max_value = -inf;
max_Dam = 0;
max_Ca = 0;

for Dam = Dam_range
    for Ca = Ca_range
        current_value = L(Dam, Ca);
        if current_value > max_value
            max_value = current_value;
            max_Dam = Dam;
            max_Ca = Ca;
        end
    end
end

% Exibindo os resultados
disp(['Valor mínimo da função L = ', num2str(min_value), ' (m)']);
disp(['Ponto mínimo ocorre para Dam = ', num2str(min_Dam), ' e Ca = ', num2str(min_Ca)]);
disp('--------------------------------------------------------------------------------');
disp(['Valor máximo da função L = ', num2str(max_value), ' (m)']);
disp(['Ponto máximo ocorre para Dam = ', num2str(max_Dam), ' e Ca = ', num2str(max_Ca)]);

% Plotando a função L(Dam, Ca)
[X, Y] = meshgrid(Dam_range, Ca_range);  % Criando a malha de pontos
Z = L(X, Y);                            % Calculando os valores de L

% Criando o gráfico 3D
figure;
surf(X, Y, Z);
colormap jet; %Aleterar as cores do mapa
xlabel('Dam [m²/s]');
ylabel('Ca [mol/m³]');
zlabel('L [m]');
title('Gráfico 3D de L(Dam, Ca)');
colorbar;

