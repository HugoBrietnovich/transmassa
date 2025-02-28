% Definir os parâmetros
Ca1 = 10;
Ca2 = 3;
Ct = 1000;
Dam = 10e-4;
r1 = 0.1;
r2 = 0.35;

x1 = 0;
x2 = 2;
num_points = 21;

% Definindo a e b
a = (r2 - r1) / (x2 - x1);
b = r1 - ((r2 - r1) / (x2 - x1)) * x1;

% Calculando a integral de Ca de Ca1 a Ca2 usando uma aproximação numérica (Método Trapezoidal)
integrand_Ca = @(Cax) 1 / (Ct - Cax);  % Função para integrar
% Aproximando a integral de Ca
IntCa = (integrand_Ca(Ca1) + integrand_Ca(Ca2)) * (Ca2 - Ca1) / 2;

% Integral calculada de x:
IntX = 57.14612;

% Calculando Na
Na = (-pi) * Dam * Ct * (IntCa / IntX);

% Lista para armazenar os resultados de Ca
Ca_values = [];

% Função de verificação da integral para evitar grandes erros numéricos
integrand_function = @(x) 1 / ((a * x + b)^2);

% Calculando Ca para diferentes valores de x
for x = linspace(x1, x2, num_points)
    % Calcular a integral de x de forma explícita (sem usar trapz)
    integral_val = 0;
    % Somando a integral de forma simples usando o método do somatório
    n_steps = 100;  % número de passos para integração
    dx = (x - x1) / n_steps;
    for i = 1:n_steps
        x_step = x1 + (i - 1) * dx;
        integral_val = integral_val + integrand_function(x_step) * dx;
    endfor

    % Calcular Ca usando a equação fornecida
    Ca = Ct - ((Ct - Ca1) * exp((Na * integral_val) / (pi * Dam * Ct)));
    Ca_values = [Ca_values, Ca];  % Armazenar o valor de Ca
endfor

% Gerar o gráfico
plot(linspace(x1, x2, num_points), Ca_values);
xlabel('x (metros)');
ylabel('Ca (Kg/m^3)');
title('Concentração de A (Ca) ao longo de x');
legend('Ca');
grid on;

