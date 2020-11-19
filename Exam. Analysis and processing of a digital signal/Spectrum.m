function [magnitudePositiveFrequencies, frequency] = Spectrum(nameOfSignal, sig, fs)

% This is to find the power of 2 nearest and bigger than the signal's size
N = length(sig);
P = pow2(ceil(log2(N)));

% This is to find fft
fft_of_signal_0pad = fft(sig,P)/P;
fft_of_signal_0pad = fftshift(fft_of_signal_0pad);
magnitude = abs(fft_of_signal_0pad);

% Then we need to multiply this by 2 because we deleted half of the fft 
% => lost half the power. So we get this power back by multiplying by 2.
% Still we will not get the exact amplitudes (1, 2, 3 for the test signal)
% because the 0 padding distributes the power of the signal

magnitudePositiveFrequencies = 2*magnitude(P/2:end);
i = -(P-1)/2 : (P-1)/2;
F = i/P*fs;
frequency = F(P/2:end);

plot(frequency, magnitudePositiveFrequencies);
grid on;
xlabel("Frequency (Hz)");
ylabel("Magnitude");
title("The magnitude spectrum of the " +nameOfSignal);
legend("The magnitude spectrum of the " +nameOfSignal);

% The reason why we divided the fft by the signal's length is because we
% want to normalise this fft so later we can compare 2 ffts
% For example s1 and s2 have peaks at frequency f but the peak of s1 is 
% higher, we say that f is less important to s2 than to s1 