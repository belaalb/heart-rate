clear
clc
close all;

% Conenctando ao Arduino, que esta na COM3:
a = arduino('COM9');

Fs = 500;                       % Frequência de amostragem
tempo = 60;                     % Tempo total de duração do sinal
L = 4;                          % Duração de cada janela (em segundos)
n_janelas = tempo/L;            % Número total de janelas
total_amostras = L*Fs;          % Total de amostras por janela
N_total = tempo*Fs;             % Quantidade de amostras no sinal completo
pulse_comp = zeros(1, N_total); % Sinal completo


% Aquisição do sinal de uma única vez
for i = 1:N_total
        pulse_comp(1, i) = a.analogRead(2);                     % Aquisição de dados do arduino
end;


figure('units','normalized','outerposition',[0 0 1 1]);         % Maximiza a figura
subplot(1,2,1)
y_total = fft(pulse_comp);                                      % Cálculo da DFT
shift_y_total = fftshift(y_total);                              % Desloca o sinal no domínio da frequência  
g_total = -Fs/2:(Fs/N_total):Fs/2-(Fs/N_total);                 % Cria vetor de frequências
plot(g_total, abs(shift_y_total).^2, 'm');
xlabel('Frequência em Hertz')
ylabel('Amplitude')
title('Espectro do sinal considerando todas as amostras')


% DFT de cada janela do sinal
for n = 1:n_janelas        
    
    pulse = pulse_comp(1, (n-1)*total_amostras + 1:n*total_amostras); 
    
    % Cálculo da DFT
    N = total_amostras;
    y = fft(pulse);                                     % Cálculo da DFT
    shift_y = fftshift(y);                              % Desloca o sinal no domínio da frequência  
    g = -Fs/2:(Fs/N):Fs/2-(Fs/N);                       % Cria vetor de frequências
    subplot(1,2,2)
    h = plot(g, abs(shift_y).^2, 'b');
    xlabel('Frequência em Hertz')
    ylabel('Amplitude')
    title('Espectro de cada janela')
    
    refreshdata(h, 'caller')                            % Atualiza plot
    drawnow; pause(.5)
end;