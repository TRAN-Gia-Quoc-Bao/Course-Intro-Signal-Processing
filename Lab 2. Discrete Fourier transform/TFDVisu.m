function [magnitude, phase, frequency] = TFDVisu(sig, fe)
fft_of_signal = fftshift(fft(sig)/length(sig));
magnitude = abs(fft_of_signal);
phase = angle(fft_of_signal);
M = length(sig);
frequency = linspace(-fe/2, fe/2, M);

% The reason why we divided the fft by the signal's length is because we
% want to normalise this fft so later we can compare 2 ffts
% For example s1 and s2 have peaks at frequency f but the peak of s1 is 
% higher, we say that f is less important to s2 than to s1 



