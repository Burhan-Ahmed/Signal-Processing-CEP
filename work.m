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

x = glitchStartSample:glitchEndSample;
y_interp = interp1([glitchStartSample-1, glitchEndSample+1], [y(glitchStartSample-1), y(glitchEndSample+1)], x, 'linear');

y_corrected = y;
y_corrected(x) = y_interp;

filterOrder = 30; 
cutoffFreq = 0.5;

b = fir1(filterOrder, cutoffFreq, 'low');

correct_signal = filter(b, 1, y_corrected);
correct_signal = min(max(correct_signal, -1), 1);

tSec = (0:length(y)-1) / Fs; % Time vector in seconds
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
plot(tSec, correct_signal);
xlabel('Time (s)');
ylabel('Amplitude');
title('Improved Audio Waveform with Glitch Smoothing');

% Save the corrected audio
audiowrite('improved_audio_file.wav', correct_signal, Fs);
