%%
% Nir Gavrielov & Hadar Sharvit
%% constants  
sample_frequency = 100000;
sample_period = 1/sample_frequency; 
filename = 'data.xlsx';
[~,sheets] = xlsfinfo(filename);
f = figure('Position', get(0, 'Screensize'));
t = tiledlayout(f, 2,3);
%f2 = figure('Position', get(0, 'Screensize'));
%t2 = tiledlayout(f2, 2,3);
title(t, 'different wave types in fourier space, Sampling rate = 4000Hz, Wave Frequency = 100Hz', 'FontSize', 25);
xlabel(t, 'Frequency(Hz)','FontSize',12)
ylabel(t, 'Amplitude(Volts)','FontSize',12)

%% calculate fourier
for i=1:length(sheets)
    data = readtable(filename,'Sheet',i,'ReadVariableNames',false);
    voltage = data.Var2;  
    time = data.Var1;          
    len_of_signal = length(time);
    %nexttile(t2);
    if strcmp(sheets(i), 'square')
        figure;
        plot(time, voltage);
    end
    %plot(time, voltage);

    %% compute fft
    fft_data= fft(voltage);
    P2=abs(fft_data/len_of_signal);
    P1 = P2(1:len_of_signal/2+1);
    P1(2:end-1)=2*P1(2:end-1);
    frequency = sample_frequency*(0:(len_of_signal/2))/len_of_signal;

    %% plot data
    nexttile(t);
    plot(frequency,P1);
    title(sheets(i),'FontSize',12)
    grid on
    
    %% reverse transform
    if strcmp(sheets(i),'square')
        rev_P1 = ifft(P1);
        len = length(rev_P1);
        time(1: len) = 2 * time(1:len); % casue only took positive values in fft
        nexttile(t);
        plot(time(1:len),real(rev_P1));
        xlabel('time(sec)','FontSize',12)
        ylabel('Amplitude(Volts)','FontSize',12)
        general_title = 'Reverse Fourier Transform of'; 
        title([general_title sheets(i)],'FontSize',12)
        grid on
        %saveas(gcf, 'inverse sine wave.jpg');  % inverse transform graph
    end
end
%saveas(t, 'fourier waves.jpg');  %all waves fourier space multi-plot

