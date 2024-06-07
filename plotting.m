clc
clear all
close all

[signal,Fs] = audioread('Noisy.wav');
signal= signal(:,1);
info = audioinfo('Noisy.wav');
t = 0:(1/Fs):(info.Duration-1/Fs);      

Y = fft(signal);
N = length(signal);
P2 = abs(Y/N);
P1 = P2(1:(N/2)+1);
P1(2:end) = 2*P1(2:end);
f = Fs*(0:(N/2))/N;   

figure;
plot(t,signal)
title('Orginal Audio Signal in Time Domain')
xlabel('time')
ylabel('Amplitude')
grid on
                      
figure;
plot(f,P1) 
title('Single-Sided Amplitude Spectrum of Original Signal')
xlabel('Freq (Hz)')
ylabel('Amplitude')
grid on