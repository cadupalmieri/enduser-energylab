close all;
clear all;


delete(instrfind)
s=serial('/dev/tty.SLAB_USBtoUART','BaudRate',230400);
s.ReadAsyncMode = 'continuous';
fopen(s); 

C = 1;
t=1;
amostras = 50;

    
   while t < amostras+1;
       fwrite(s,76,'uint16') %write data
         i=1;
       while 1
           C=fscanf(s);
           if C ~= 'F';
           c_str = regexp(C,',','split');
           data(1,i) = str2double(c_str(1))/10;
           data(2,i) = str2double(c_str(2))/10;
           data(3,i) = str2double(c_str(3))/10;
           i=i+1;
           else
               break;
           end
   end
   
frequencia = data(1,:);
tensao = data(2,:);
corrente = data(3,:);
index = num2str(amostras);

%aparelho = 'vazio';          out=[0 0 0 0 0 0 0 1];

%aparelho = 'liquidificador'; out=[0 0 0 0 0 0 1 0];
%aparelho = 'torradeira';     out=[0 0 0 0 0 1 0 0];
%aparelho = 'carregador';     out=[0 0 0 0 1 0 0 0];

%aparelho = 'liqui+torra';    out=[0 0 0 1 0 0 0 0];
%aparelho = 'liqui+carrega';  out=[0 0 1 0 0 0 0 0];
aparelho = 'torra+carrega';  out=[0 1 0 0 0 0 0 0];
%aparelho = 'todos';          out=[1 0 0 0 0 0 0 0];

nome = ['aparelho/' aparelho];

entradas(t,:) = corrente;
saidas(t,:) = out;



figure(1);
stem(frequencia,corrente);
title(nome);
drawnow

t=t
t = t + 1;
end

log = [entradas saidas];
save([nome '.mat'],'log');
fclose(s);
delete(s)
clear s