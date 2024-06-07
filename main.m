
clc;
clear all;
close all;

[y, Fs] = audioread('Noisy.wav');

size = 1024;
overlap = 512; 
length_fft = size;

[coff, f, t] = spectrogram(y, size,overlap, length_fft, Fs);

[freq, freqIndex] = max((coff));

glitch_Threshold = 1; 
startIndex = find(abs(diff(freqIndex)) > glitch_Threshold, 1); 

endIndex = startIndex;

for i = startIndex + 1 : length(freqIndex)
    if abs(freqIndex(i) - freqIndex(startIndex - 1)) < glitch_Threshold
        endIndex = i;
        break;
    end
end

StartMilli = t(startIndex);
EndMilli = t(endIndex);

DurationSec = EndMilli - StartMilli;

StartHour = floor(StartMilli / 3600);
StartMin = floor((StartMilli - StartHour * 3600) / 60);
StartMilli = StartMilli - StartHour * 3600 - StartMin * 60;

EndHour = floor(EndMilli / 3600);
EndMin = floor((EndMilli - EndHour * 3600) / 60);
EndMilli = EndMilli - EndHour * 3600 - EndMin * 60;

fprintf('Glitch starts at %02d:%02d:%06.3f and ends at %02d:%02d:%06.3f\n', ...
    StartHour, StartMin, StartMilli, ...
    EndHour, EndMin, EndMilli);
fprintf('Glitch duration: %f seconds\n', DurationSec);