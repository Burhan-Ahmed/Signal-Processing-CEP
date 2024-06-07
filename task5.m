clc
clear all;
close all;

[x, fs] =audioread('gg.wav');
t = (0:length(x)-1)/fs;

 Fc = 50;
 order = 30; 
 lowFil = fir1(order, Fc/(fs/2), 'low');
 filterSignal = filtfilt(lowFil, 1, x);

figure;
plot(t,x);
xlabel('Time (s)');
ylabel('Amplitude');
title('Orignal Waveform');

 figure;
 plot(t,filterSignal);
 xlabel('Time (s)');
 ylabel('Amplitude');
 title('Filtered Waveform (Low-Pass Filter)');
 
audiowrite('Cleaned_Sinusoid.wav', filterSignal, fs);