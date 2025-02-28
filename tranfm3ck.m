clc;
clear;

#4D

#Eixo x: distância da fonte (R)
#Eixo y: o coeficiente de difusão (Dam)
#Eixo z: a Pressão parcial da espécie que sublima (Pa)

#Cor: tempo para sublimação de uma camada da espécie
#Parametro P: a pressão de vapor da espécie que sublima


% Definição das variáveis
Rinf = 0.01;  % Limite inferior da distância da fonte [m]
Rsup = 0.1;   % Limite superior da distância da fonte
pR = (Rsup - Rinf) / 10;

Daminf = 0.00005;  % Limite inferior do coeficiente de difusão [m²/s]
Damsup = 0.0001;   % Limite superior do coeficiente de difusão
pDam = (Damsup - Daminf) / 10;

Painf = 2.88;  % Limite inferior da pressão parcial [Pa]
Pasup = 3.52;  % Limite superior da pressão parcial
pPa = (Pasup - Painf) / 10;

% Refinamento das fatias para visualização
pRs = pR / 5;
pDams = pDam / 5;
pPas = pPa / 5;

NR = round((Rsup - Rinf) / pR);
NDam = round((Damsup - Daminf) / pDam);
NPa = round((Pasup - Painf) / pPa);

[R, Dam, Pa] = meshgrid(Rinf:pR:Rsup, Daminf:pDam:Damsup, Painf:pPa:Pasup);
Rslice = Rinf:pRs:Rsup;
Damslice = Daminf:pDams:Damsup;
Paslice = Painf:pPas:Pasup;

% Parâmetros físicos
colormap(jet);
nhz = 1; % Contador do horizonte de dados
Rg = 8.314; % Constante dos gases [J/(mol*K)]
T = 298;   % Temperatura [K]

% Inicialização de variáveis para iteração
P = 4;       % Pressão inicial [Pa]
PLim = 100;  % Pressão limite [Pa]
passoP = 10; % Incremento de pressão [Pa]
pontosp = 0;

abc = []; % Vetor para armazenar dados 4D

while (P <= PLim)
    % Cálculo do tempo de sublimação
    v = (R.^2) ./ ((Dam .* P) ./ (Rg * T) .* log(P ./ (P - Pa)));

    % Plotagem do gráfico 3D com slices
    subplot(1,2,1);
    s1 = slice(R, Dam, Pa, v, Rslice, Damslice, Paslice);
    set(s1, 'FaceAlpha', 0.08);
    shading interp;
    view(-45, 25);
    colorbar('west');
    xlabel('Distância da Fonte (R) [m]');
    ylabel('Coef. Difusão (Dam) [m²/s]');
    zlabel('Pressão Parcial (Pa) [Pa]');
    title('Distribuição do Tempo de Sublimação');

    pause(0.0001);

    % Gráfico de evolução do parâmetro P
    subplot(1,2,2);
    scatter(nhz, P, 50, 'filled'); hold on;
    xlabel('Horizonte de Dados');
    ylabel('Pressão de Vapor (P) [Pa]');
    title('Evolução de P');
    nhz = nhz + 1;

    % Armazenamento dos valores calculados
    for c = 1:NPa+1
        for i = 1:NDam+1
            for j = 1:NR+1
                v_atual = (R(i,j,c)^2) / ((Dam(i,j,c) * P) / (Rg * T) * log(P / (P - Pa(i,j,c))));
                abc = [abc; R(i,j,c), Dam(i,j,c), Pa(i,j,c), v_atual, P];
            end
        end
    end

    P = P + passoP;
    pontosp = pontosp + 1;
end

% Determinação do tempo mínimo de sublimação
[~, vmin] = min(abc(:,4));
fprintf('\nPonto de Mínimo:  R = %.5f  Dam = %.5f  Pa = %.5f  v = %.5f  P = %.5f', abc(vmin,:));

% Determinação do tempo máximo de sublimação
[~, vmax] = max(abc(:,4));
fprintf('\nPonto de Máximo:  R = %.5f  Dam = %.5f  Pa = %.5f  v = %.5f  P = %.5f', abc(vmax,:));
