clc;
clear all;

#3D

#construa visualizações de dados
#Eixo x: a pressão de vapor da espécie que sublima
#Eixo y: o coeficiente de difusão (Dam)
#Eixo z: tempo para sublimação de uma camada da espécie

% Definição das constantes
ro = 1162;  % Densidade da substância [kg/m³]
Rg = 8.314; % Constante dos gases [J/(mol*K)]
Rp = 0.05;  % Raio da partícula [m]
T = 298;    % Temperatura [K] (convertida de 25°C para Kelvin)
P = 10^5;   % Pressão total [Pa]

% Número de pontos laterais do grid
N = 50;

% Eixo X: Pressão de vapor da espécie que sublima [Pa]
Var1 = linspace(120, 150, N);

% Eixo Y: Coeficiente de difusão (Dam) [m²/s]
Var2 = linspace(0.00005, 0.0001, N);

% Criando a malha para cálculo
[xx, yy] = meshgrid(Var1, Var2);

% Definição da equação para Na
Na = ((4 .* pi .* yy .* P .* Rp) ./ (Rg .* T)) .* log(P ./ (P - xx));

% Cálculo do tempo de sublimação (Eixo Z)
z = (((ro .* Rg .* (Rp.^2) .* T)) ./ ((2 .* yy .* xx .* Na) .* (1 ./ log(P ./ (P - xx)))));

% Gráfico 3D da superfície
figure;
surf(xx, yy, z);
shading interp;
colormap(jet);
colorbar;
xlabel("Pressão de Vapor [Pa]");
ylabel("Coef. de Difusão (Dam) [m²/s]");
zlabel("Tempo de Sublimação [s]");
title("Tempo de Sublimação em Função da Pressão de Vapor e Difusão");

% Ajuste de escala para melhor visualização
zlim([0, max(z(:))]);

% Criando o vetor de dados 4D
abc = zeros(N*N, 3);
k = 1;
for i = 1:N
    for j = 1:N
        abc(k, :) = [xx(i, j), yy(i, j), z(i, j)];
        k = k + 1;
    end
end

% Encontrando os valores máximo e mínimo do tempo de sublimação
t_max = max(abc(:,3));
t_min = min(abc(:,3));
fprintf("\nTempo máximo de sublimação: %.5f s", t_max);
fprintf("\nTempo mínimo de sublimação: %.5f s\n", t_min);
