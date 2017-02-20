clear
clc
close all

Fs = 640;                       % Frequência de amostragem
tempo = 60;                     % Tempo total de duração do sinal
L = 4;                          % Duração de cada janela (em segundos)
n_janelas = tempo/L;            % Número total de janelas
total_amostras = L*Fs;          % Total de amostras por janela
load('s0010_rem.mat');          % Leitura do sinal da base de dados
pulse = val(1, :);              % Seleciona o primeiro canal do sinal da base de dados

figure('Position', [650 50 570 510]); % Posiciona a figura

for n = 1:n_janelas        
    subplot(1,2,1)
    y = val(1, (n-1)*total_amostras + 1:n*total_amostras);  % Seleção da janela
    h = plot(y, 'g');                                       % Plota a janela
    title('Sinal analógico - Eletrocardiograma')
    xlabel('Amostras')
    ylabel('Amplitude do sinal (Volts)');
    wl = 2;                                                 % Frequência de corte inferior  
    wh = 22;                                                % Frequência de corte superior
    [b, a] = butter(5, wl/(Fs/2), 'high');                  % Filtro de Butterworth de ordem 4
    filt_y = filter(b, a, y);                               % Filtragem do sinal
    %sqfilt_y = filt_y;
    sqfilt_y = filt_y.^2;                                   % Elevar a amplitude ao quadrado para diferencial os picos
    subplot(1,2,2)
    plot(sqfilt_y, 'r');                                    % Plota sinal filtrado
    title('Sinal filtrado')
    xlabel('Amostras')
    ylabel('Amplitude do sinal ao quadrado (Volts²)');     
   
   
    refreshdata(h, 'caller')                                % Atualiza plot
    drawnow; pause(.4)
    
        
    [peaks, ~] = peakfinder(sqfilt_y, 70000);              % Detecta picos no sinal e salva em peaks
    count = 1;
    diff = 0;
    while((diff < 400) && (count < length(peaks)))          % Calcula a quantidade de amostras entre os picos mais próximos
        diff = abs(peaks(count + 1) - peaks(count));        % Distância mínima entre picos é 400 amostras  
        count = count + 1;
    end;
    
    T = diff/Fs;                                            % Período entre batimentos
    bpm(1, n) = (1/T)*60;                                   % Cálculo da frequência cardíaca
    (1/T)*60                                                % Escreve quantidade de batimentos na tela
 end;