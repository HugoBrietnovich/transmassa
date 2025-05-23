% === DADOS A SALVAR ===

%ATENCAO
%Insira esse código após o trecho em que foi definida e criada uma matriz, para fins de exemplificação irei definir uma matriz genérica.

nomematriz = [1 2 3 4; 5 6 7 8; 9 10 11 12; 13 14 15 16];



% === NOMES DAS VARIAVEIS (Cabecalho) ===

% Aqui voce escreve manualmente os nomes das variaveis/colunas que estarão no excell:

% Essa parte é só formatacao, nao vai interferir diretamente nos valores, apenas como eles são apresentador no excell

cabecalho = {'Pressao inicial', 'Pressao final', 'Deslocamento', 'Toxicidade de A'}; % O código vai adaptar as colunas com a quantidade de variaveis então se tiver 4+ variáveis basta acrescentar mais títulos com formatação igual aos anteriores, se tiver menos que 4 variaveis basta tirar os títulos.



% === NOME DO ARQUIVO ===
% Defina o nome do arquivo csv. Apenas nao tire o ".csv"

nome_arquivo = 'Oi_sou_s_planilha_de_teste.csv'; % Aqui basta alterar qual o nome que vc deseja que o arquivo csv tenha, dá pra trocar o formato do arquivo, mas n recomendo pq deu erro.



% === CRIAÇÃO DO ARQUIVO CSV ===
% N precisa alterar nada aqui

% Nesse trecho o octave esta colocando os titulos no arquivo csv e pulando uma linha para que os dados da matriz sejam inseridos dali pra baixo.

fid = fopen(nome_arquivo, 'w');  % abre o arquivo para escrita

% Escreve os nomes das colunas (cabeçalho)
fprintf(fid, '%s', cabecalho{1});
for i = 2:length(cabecalho)
    fprintf(fid, ';%s', cabecalho{i});  % usa ; como separador
end
fprintf(fid, '\n');  % pula para a próxima linha

% ==============================

% === SALVANDO OS DADOS NO VSC ===

% agr o codigo vai estar inserindo os dados no arquivo

% ATENCAO

% Altere colocando o nome da matriz em todos os espaços aqui embaixo

% Escreve os dados numéricos
for i = 1:size(nomematriz, 1)                       % substitua "nomematriz" pelo nome da matriz que vc quer pegar os valores
    fprintf(fid, '%g', nomematriz(i, 1));           % substitua "nomematriz"
    for j = 2:size(nomematriz, 2)                   % substitua "nomematriz"
        fprintf(fid, ';%g', nomematriz(i, j));      % substitua "nomematriz"
    end
    fprintf(fid, '\n');  % nova linha a cada linha de dados
end

fclose(fid);  % fecha o arquivo

% É isso por hoje pessoal.

% Gerador de planilhas concluido AH EHHHH!!
% Para esclarecer duvidas só falar com eu @zophictor
