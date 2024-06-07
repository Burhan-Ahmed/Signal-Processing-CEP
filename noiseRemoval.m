clc;
clear all;
close all;

[y, Fs] = audioread('Noisy.wav');

windowSize = 1024; 
overlap = 0.5;
nfft = 1024; 

[spectrogram, f, t] = spectrogram(y, windowSize, round(overlap*windowSize), nfft, Fs);

[maxFreq, maxFreqIdx] = max(abs(spectrogram), [], 1);

glitchThreshold = 1; 
glitchStartIdx = find(abs(diff(maxFreqIdx)) > glitchThreshold, 1, 'first'); 
glitchEndIdx = glitchStartIdx;

for i = glitchStartIdx + 1 : length(maxFreqIdx)
    if abs(maxFreqIdx(i) - maxFreqIdx(glitchStartIdx - 1)) < glitchThreshold
        glitchEndIdx = i;
        break;
    end
end

glitchStartSample = round(t(glitchStartIdx) * Fs);
glitchEndSample = round(t(glitchEndIdx) * Fs);
glitchDuration = glitchEndSample - glitchStartSample;

baseFreq = 50; 
cutoffFreq = baseFreq / (Fs / 2); 
order = 30; 
fil = fir1(order, cutoffFreq, 'low');

signal_convolved = conv(y(glitchStartSample:glitchEndSample),fil, 'same');
%original_max = max(abs(signal(1:5)));
%filtered_max = max(abs(filtered_signal));
%gain_factor = original_max / filtered_max;
%signal_convolved=signal_convolved;

signal_corrected = y;
signal_corrected(glitchStartSample:glitchEndSample) = signal_convolved;

tSec = (0:length(y)-1) / Fs; 
figure;
subplot(2,1,1);
plot(tSec, y);
hold on;
plot(tSec(glitchStartSample:glitchEndSample), y(glitchStartSample:glitchEndSample), 'ro', 'MarkerSize', 10);
xlabel('Time (s)');
ylabel('Amplitude');
title('Original Audio Waveform with Glitch Highlighted');
legend('Original Audio', 'Glitch');

subplot(2,1,2);
plot(tSec, signal_corrected);
xlabel('Time (s)');
ylabel('Amplitude');
title('Improved Audio Waveform with Glitch Smoothing');

% Save the corrected audio
audiowrite('improved_audio_file.wav', signal_corrected, Fs);
