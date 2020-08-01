% Limpa o console
clc
clear all
close all

% Inicializa dos dados para treino e teste da RNA
[train_data, test_data, class_train, class_test] = Concatena();

% Define a quantidade de entradas
feature_length=128;  

% Parametrizacaoo da RNA
num_neuronios=10;                  
num_saidas=8;                   
num_entradas=feature_length+1;    

% Hiperparametros da RNA
eta = 0.01; 
epocas = 200;   
epsilon = 0.0001;

% Inicializacao dos pesos
p_camadaescondida= 0.5 - randn(num_neuronios,num_entradas);    
p_camadasaida= 0.5 - randn(num_saidas,num_neuronios);    

% Inicializacao de matrizes e variaveis
Output = zeros(8,size(train_data,2));
delta_saida = zeros(num_saidas,1);
delta_escondida = zeros(num_neuronios,1);
SE = zeros(size(train_data,2),epocas);
MSE = zeros(epocas,1);
TCE = zeros(epocas,1);
MSEAnt = 0;
soma_erro = 0;

% Inicio do treinamento da rede para a quantidade de epocas
for j=1:epocas
    
    for k=1:size(train_data,2)

        %Adicionando o bias (1)
        Input= [1; train_data(:,k)];  

        % Camada de Entrada
        n1 = p_camadaescondida * Input;
        a1=logsig(n1);

        % Camada Escondida
        n2 = p_camadasaida * a1;
        a2=logsig(n2);

        % Camada de Saida
        Output(:,k)=a2;
        e = class_train(:,k) - Output(:,k);

        % Erro Quadratico
        SE(k,j) = .5 * sum(e.^2);   
        
        % Retropropagacao
        Y2 = dlogsig(n2,a2);
        for ns = 1:num_saidas
            delta_saida(ns,:) = e(ns,:) * Y2(ns,:);
        end
        
        Y1 = dlogsig(n1,a1);
        for ne = 1:num_neuronios
            for ns = 1:num_saidas
                soma = p_camadasaida(ns,ne)*delta_saida(ns,:)';
            end
            delta_escondida(ne,:) = soma * Y1(ne,:);  
        end
        
        % Reajuste dos pesos das camadas
        p_camadaescondida = p_camadaescondida + eta * delta_escondida * Input';  % input layer neurons weight update
        p_camadasaida = p_camadasaida + eta * delta_saida * a1';    % hidden layer neurons weight update

    end

    % Erro Quadratico Meedio
    MSE(j)= mean(SE(:,j));       

    % Extracaoo das matrizes de saida desejada e calculada
    [M,I] = max(Output);
    [MT,IT] = max(class_train);

    % Definicaoo da Taxa de Acertos
    TCE(j)=length(find(I-IT==0))*100/length(Output);

    % Verificacaoo se a rede atingiu a tolerancia
    if abs(MSE(j) - MSEAnt)<= epsilon
       break; 
    end
    
    MSEAnt = MSE(j);
end

% Regulando a matriz de predicaoo com apenas 0 e 1
predictM = zeros(8,size(Output,2));
for c = 1:size(Output,2)
    predictM(IT(c),c) = 1;
end

% Plot da Matriz de Confusaoo de Dados de Treino
plotconfusion(class_train,predictM);

% Salva os pesos obtidos no treino para serem utilizados posteriormente
save camadaescondida p_camadaescondida 
save camadasaida p_camadasaida

% Geracaoo dos Graficos dos Dados obtidos
figure
semilogy(MSE)
xlabel('Training epocas')
ylabel('MSE')
title('Objective function')

figure
plot(TCE)
xlabel('Training epocas')
ylabel('Classification accuracy (%)')
title('Classification performance (Training)')

figure
plot(class_train,'or')
hold on
plot(round(Output))

legend('Actual class','Predicted class using MLP')
xlabel('Training sample #')
ylabel('Class Label')
title('Classification performance (Training)')

Training_Accuracy=length(find(I-IT==0))*100/length(Output);

% Validacaoo da rede com dados de teste
Output=zeros(8,size(test_data,2));

for k=1:size(test_data,2)

        Input= [1; test_data(:,k)];

        n1 = p_camadaescondida * Input;
        a1=logsig(n1);    

        n2 = p_camadasaida*a1;
        a2=logsig(n2);    

        Output(:,k)=a2;

        [M,I] = max(Output);
        [MT,IT] = max(class_test);        
end

% Regulando a matriz de predicaoo com apenas 0 e 1
predictM = zeros(8,size(Output,2));
for c = 1:size(Output,2)
    predictM(IT(c),c) = 1;
end

% Plotando a Matriz de Confusaoo dos Dados de Teste
plotconfusion(class_test,predictM);

Testing_Accuracy= length(find(I-IT==0)) * 100 / length(Output);

% Gerando grafico dos dados de Teste
figure
plot(class_test,'or')
hold on
plot(round(Output))
legend('Actual class','Predicted class using MLP')
xlabel('Training sample #')
ylabel('Class Label')
title('Classification performance (Test)')


%[Training_Accuracy Testing_Accuracy]
