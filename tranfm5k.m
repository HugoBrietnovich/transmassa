clc;
clear;

% Parâmetros físicos e geométricos
L = 10;
Dam = 0.0001;
Pa = 130000;
Rg = 8.314;
T = 298;

% Intervalos e passos
yinf = 0.1; ysup = 0.5; py = 0.2;
zinf = 0.1; zsup = 0.5; pz = 0.2;
xinf = 0.2; xsup = 1.0; px = 0.2;

pxs = 0.01; pys = 0.01; pzs = 0.01;

% Criando malha tridimensional
[x, y, z] = meshgrid(xinf:px:xsup, yinf:py:ysup, zinf:pz:zsup);
xslice = xinf:pxs:xsup;
yslice = yinf:pys:ysup;
zslice = zinf:pzs:zsup;

colormap(jet);

% Equação de fração vazia e tortuosidade
w = 40000.*(y + z) - 40000.*y ...
    - 36.114.*(log(max(1000*(y + z) + 0.21, eps)) - log(max(1000*y + 0.21, eps))) ...
    - 31.42857.*(log(max(9524.93271*(y + z) + 2.00011, eps)) ...
    - log(max(9524.93271*(y + z) - 9524.93271*y + 2.00011, eps)) ...
    + log(max(9524.93271*y + 0.00011, eps)));


% Cálculo da vazão
v = (2.*pi.*(x ./ (pi .* ((z + y).^2 - y.^2))) .* Pa .* Dam) ./ (Rg .* T .* (w + eps));

% Encontrar o ponto ótimo de vazão (máxima vazão)
[max_vazao, idx] = max(v(:));  % Encontrar o valor máximo de vazão
[x_max, y_max, z_max] = ind2sub(size(v), idx);  % Obter os índices do ponto máximo

% Mostrar as coordenadas e o valor da vazão
disp(['Ponto ótimo de vazão encontrado em:']);
disp(['x = ', num2str(x(x_max, y_max, z_max))]);
disp(['y = ', num2str(y(x_max, y_max, z_max))]);
disp(['z = ', num2str(z(x_max, y_max, z_max))]);
disp(['Vazão máxima: ', num2str(max_vazao)]);

% Plotagem dos slices 3D
s1 = slice(x, y, z, v, xslice, yslice, zslice);
set(s1, 'facealpha', 0.3); % Ajustando transparência
shading interp;
view(-45, 30);
colorbar;

% Adicionar marcador para o ponto ótimo de vazão
hold on;
plot3(x(x_max, y_max, z_max), y(x_max, y_max, z_max), z(x_max, y_max, z_max), 'ko', 'MarkerFaceColor', 'r', 'MarkerSize', 8);  % Marcador para o ponto ótimo

% Labels e título
xlabel("Volume disponível [m³]");
ylabel("Valor de R1 [m]");
zlabel("Valor da Espessura do leito: R1 + Espessura = R2 [m]");
title("Color Bar: Vazão da espécie A (Na) [m³/s]");

hold off;
