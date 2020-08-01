% Funcaoo de leitura de todos os dados capturados
% e separacao do conjunto total em dados de treino e teste
function [in_train, in_test, out_train, out_test] = Concatena() 
    
    % Limpa o terminal
    clc
    clear all
    close all

    % Faz a leitura dos arquivos
    a = load('Dados/liquidificador.mat') ;
    b = load('Dados/torradeira.mat') ;
    c = load('Dados/vazio.mat') ;
    d = load('Dados/liqui+torra.mat') ;
    e = load('Dados/carregador.mat') ;

    a = a.log;
    b = b.log;
    c = c.log;
    d = d.log;
    e = e.log;

    swap = [a.' b.' c.' d.' e.'].';

    % Randomiza as linhas da matriz geral gerada
    random_log = swap(randperm(size(swap, 1)), :);
    log = random_log;
    
    % Define a quantidade de amostras e separa os
    % dados de entrada e saida da rede
    amostras = 128;
    entradas = log(:,1:amostras);
    saidas = log(:,amostras+1:amostras+8);
    
    % Separa os dados de Treino (80%)
    in_train = entradas(1:200,:);
    out_train = saidas(1:200,:);
   
    % Separa os dados de Teste (20%)
    in_test = entradas(201:250,:); 
    out_test = saidas(201:250,:);
    
    % Faz a transposta das matrizes
    in_train = in_train.';
    in_test = in_test.';
    
    out_train = out_train.';
    out_test = out_test.';
        
end