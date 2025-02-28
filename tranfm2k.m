clc;
clear;

% Definição das variáveis
xinf = 0.00005;  % Limite inferior de Dam (difusividade no ar) [m²/s]
xsup = 0.0001;   % Limite superior de Dam
px = (xsup - xinf) / 10;

yinf = 1000;     % Limite inferior da densidade do fluido [mol/m³]
ysup = 1200;     % Limite superior da densidade do fluido
py = (ysup - yinf) / 10;

zinf = 2.88;     % Limite inferior da pressão de vapor [Pa]
zsup = 3.52;     % Limite superior da pressão de vapor
pz = (zsup - zinf) / 10;

% Refinamento das fatias para visualização
pxs = px / 5;
pys = py / 5;
pzs = pz / 5;

Nx = round((xsup - xinf) / px);
Ny = round((ysup - yinf) / py);
Nz = round((zsup - zinf) / pz);

[x, y, z] = meshgrid(xinf:px:xsup, yinf:py:ysup, zinf:pz:zsup);
xslice = xinf:pxs:xsup;
yslice = yinf:pys:ysup;
zslice = zinf:pzs:zsup;

% Parâmetros físicos
colormap(jet);
nhz = 1; % Contador do horizonte de dados
ht = 5; #altura máxima do tanque de evaporação
h0 = 2.5; # Chão do tanque de evaporação
Rg = 8.314; % Constante dos gases [J/(mol*K)]
T = 298;   % Temperatura [K]

% Inicialização de variáveis para iteração
p = 4;       % Pressão inicial [Pa]
pLim = 100;  % Pressão limite [Pa]
passoP = 10; % Incremento de pressão [Pa]
pontosp = 0;

abc = []; % Vetor para armazenar dados 4D

while (p <= pLim)
    % Cálculo do tempo de evaporação
    v = (((ht * h0) - ((h0^2) / 2)) ./ (((x * p) ./ (y * Rg * T)) .* log(p ./ (p - z))));

    % Plotagem do gráfico 3D com slices
    subplot(1,2,1);
    s1 = slice(x, y, z, v, xslice, yslice, zslice);
    set(s1, 'FaceAlpha', 0.08);
    shading interp;
    view(-45, 25);
    colorbar('west');
    xlabel('Dam (Difusividade no ar) [m²/s]');
    ylabel('Densidade [mol/m³]');
    zlabel('Pressão de vapor [Pa]');
    title('Distribuição do Tempo de Evaporação');

    pause(0.0001);

    % Gráfico de evolução do parâmetro P
    subplot(1,2,2);
    scatter(nhz, p, 50, 'filled'); hold on;
    xlabel('Horizonte de Dados');
    ylabel('Parâmetro P [Pa]');
    title('Evolução de P');
    nhz = nhz + 1;

    % Armazenamento dos valores calculados
    for c = 1:Nz+1
        for i = 1:Ny+1
            for j = 1:Nx+1
                v_atual = (((ht * h0) - ((h0^2) / 2)) / (((x(i,j,c) * p) / (y(i,j,c) * Rg * T)) * log(p / (p - z(i,j,c)))));
                abc = [abc; x(i,j,c), y(i,j,c), z(i,j,c), v_atual, p];
            end
        end
    end

    p = p + passoP;
    pontosp = pontosp + 1;
end

% Determinação do tempo mínimo de evaporação
[~, vmin] = min(abc(:,4));
fprintf('\nPonto de Mínimo:  x = %.5f  y = %.5f  z = %.5f  v = %.5f  p = %.5f', abc(vmin,:));

% Determinação do tempo máximo de evaporação
[~, vmax] = max(abc(:,4));
fprintf('\nPonto de Máximo:  x = %.5f  y = %.5f  z = %.5f  v = %.5f  p = %.5f', abc(vmax,:));
