clc
clear
close all

% Conenctando ao Arduino, que esta na COM3:
a = arduino('COM9');
Fs = 500;

tempo = 12;
L = 2;
n_janelas = tempo/L;
total_amostras = L*Fs;
pulse = zeros(n_janelas, total_amostras);

bpm = zeros(1, n_janelas);

%Figuras
realTime = figure('Position', [50 50 570 510]);
processed = figure('Position', [650 50 570 510]);

for n = 1:n_janelas
    
    y = zeros(1, total_amostras);                   % Sinal a ser processado
    
    for i = 1:total_amostras
        pulse(n, i) = a.analogRead(2);              % Aquisição de dados do arduino
        y(1, i) = pulse(n, i);
        
        figure(realTime)
        h = plot(y, 'r');                           % Plota cada janela de amostras
        title('Sinal analógico - Sensor de pulso')
        xlabel('Amostras')
        ylabel('Amplitude do sinal (Volts)');
        
        refreshdata(h, 'caller') 
        drawnow; pause(0.00001)
    end; 
 
    wl = 2;                                         % Frequência de corte inferior
    wh = 22;                                        % Frequência de corte superior                
    [b, x] = butter(4, wl/(Fs/2), 'high');          % Filtro de Butterworth passa-alta de ordem 4
    filt_y = filter(b, x, y);                       % Filtragem do sinal
    sqfilt_y = filt_y.^2;                           % Eleva amplitude ao quadrado
    
    figure(processed);                              
    k = plot(sqfilt_y, 'b');                        % Plota sinal filtrado
    title('Sinal filtrado')
    xlabel('Amostras')
    ylabel('Amplitude do sinal ao quadrado (Volts²)');

    refreshdata(k, 'caller') 
    drawnow; pause(0.5)
    
    [peaks, ~] = peakfinder(sqfilt_y, 50);          % Encontra os picos do sinal
    
    count = 1;
    diff = 0;
    while((diff < 400) && (count < length(peaks)))
        diff = abs(peaks(count + 1) - peaks(count));
        count = count + 1;
    end;
    
    T = diff/Fs;
    (1/T)*60
    bpm(1, n) = (1/T)*60;
    

end;