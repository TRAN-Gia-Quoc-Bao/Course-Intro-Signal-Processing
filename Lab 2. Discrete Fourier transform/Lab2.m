%% Signal processing - DFT

%% Default commands
close all;
clear all;
clc;

%% Constants
N = 256;
N_w = 32;
P_w = 32*16;
k = 12;
P = 2^k;
M = P - N;
% The signals' characteristics
Amp1 = 1;
Amp2 = 2;
f1 = 10;
f2 = 10*15.5/16;
phi1 = 6;
phi2 = 4;
% Discretize the signals
% We have 16/fe = 256/f1 => fe = 16*f1
fe = 16*f1; 
lambda1 = f1/fe;
lambda2 = f2/fe;
t = 1 : N;
% Number of shifted positions 
k1 = 1;
k2 = 20;

%% Signals

% The original signals
sig1 = Amp1*sin(2*pi*lambda1*t + phi1);
sig2 = Amp2*sin(2*pi*lambda2*t + phi2);

% FFTs of those signals
[magnitude1 phase1 frequency1] = TFDVisu(sig1, fe);
[magnitude2 phase2 frequency2] = TFDVisu(sig2, fe);
% Comment on plot of these: These have peaks at -f0 and +f0 of each signal 
% which is understandable because the FFTs of sin waves have the form 
% (A/2)*(dirac(f + f0) + dirac(f - f0)). Also this is not affected by the 
% initial phases because it concerns only the frequency domain.

% Now we shift the signals
sig1_shifted = circshift(sig1,k1);
sig2_shifted = circshift(sig2,k2);
[magnitude1_shifted phase1_shifted frequency1_shifted] = TFDVisu(sig1_shifted, fe);
[magnitude2_shifted phase2_shifted frequency2_shifted] = TFDVisu(sig2_shifted, fe);
% Comment: The effect of these shifts is that the magnitude of FFT will
% stay unchanged while the phase of FFT will be changed. The more the
% delay, the less the phase plot is spread with regards to frequency.

% Now we test some zero padding
sig1_0pad = zeros(1,P);
for i = 1 : (N-1)
    sig1_0pad(1,i) = sig1(i);
end
sig2_0pad = zeros(1,P);
for i = 1 : (N-1)
    sig2_0pad(1,i) = sig2(i);
end
% FFTs of those 0 padding signals
[magnitude1_0pad phase1_0pad frequency1_0pad] = TFDVisu_0pad(sig1_0pad, fe, P);
[magnitude2_0pad phase2_0pad frequency2_0pad] = TFDVisu_0pad(sig2_0pad, fe, P);

% Now we test the windows
w1 = rectwin(N_w);
w2 = window(@blackmanharris,N_w);
w3 = window(@hamming,N_w); 

% Now add 0 padding to the windows
w1_0pad = zeros(1,P_w);
for i = 1 : (N_w - 1)
    w1_0pad(1,i) = w1(i);
end
w2_0pad = zeros(1,P_w);
for i = 1 : (N_w - 1)
    w2_0pad(1,i) = w2(i);
end
w3_0pad = zeros(1,P_w);
for i = 1 : (N_w - 1)
    w3_0pad(1,i) = w3(i);
end

% FFTs of those 0 padding windows
[magnitude_w1_0pad phase_w1_0pad frequency_w1_0pad] = TFDVisu_0pad(w1_0pad, fe, P_w);
[magnitude_w2_0pad phase_w2_0pad frequency_w2_0pad] = TFDVisu_0pad(w2_0pad, fe, P_w);
[magnitude_w3_0pad phase_w3_0pad frequency_w3_0pad] = TFDVisu_0pad(w3_0pad, fe, P_w);

% Application of window 3 on the 2 signals
sig1_w3 = sig1.*window(@hamming,N)';
sig2_w3 = sig2.*window(@hamming,N)';

% Now we test some zero padding on the filtered signals
sig1_w3_0pad = zeros(1,P);
for i = 1 : (N)
    sig1_w3_0pad(1,i) = sig1_w3(i);
end
sig2_w3_0pad = zeros(1,P);
for i = 1 : (N)
    sig2_w3_0pad(1,i) = sig2_w3(i);
end
% FFTs of those 0 padding signals
[magnitude1_w3_0pad phase1_w3_0pad frequency1_w3_0pad] = TFDVisu_0pad(sig1_w3_0pad, fe, P);
[magnitude2_w3_0pad phase2_w3_0pad frequency2_w3_0pad] = TFDVisu_0pad(sig2_w3_0pad, fe, P);

% Load the test signal
sig_test = load('SigTest');
sig_test = sig_test.SigTest;
% Apply the 3rd window on it
sig_test_w3 = sig_test.*window(@hamming,length(sig_test))';
% Add zero padding to it
sig_test_w3_0pad = zeros(1,P);
for i = 1 : (N)
    sig_test_w3_0pad(1,i) = sig_test_w3(i);
end
% FFTs of the signal
[magnitude_test_w3_0pad phase_test_w3_0pad frequency_test_w3_0pad] = TFDVisu_0pad(sig_test_w3_0pad, fe, P);

%% Plots
figure(1);
plot(t,sig1);
grid on;
xlabel('Time (s)');
ylabel('Signal (V)');
title('The signal s1');
legend('The signal s1');

figure(2);
plot(t,sig2);
grid on;
xlabel('Time (s)');
ylabel('Signal (V)');
title('The signal s2');
legend('The signal s2');
 %%
figure(3);
subplot(211);
plot(frequency1,magnitude1);
xlabel('Frequency (Hz)');
ylabel('Magnitude spectrum (V)');
title('The magnitude spectrum of signal s1');
legend('The magnitude spectrum of signal s1');
hold on
subplot(212);
plot(frequency1,phase1);
grid on;
xlabel('Frequency (Hz)');
ylabel('Phase spectrum (Rad)');
title('The phase spectrum of signal s1');
legend('The phase spectrum of signal s1');

figure(4);
subplot(211);
plot(frequency2,magnitude2);
xlabel('Frequency (Hz)');
ylabel('Magnitude spectrum (V)');
title('The magnitude spectrum of signal s2');
legend('The magnitude spectrum of signal s2');
hold on
subplot(212);
plot(frequency2,phase2);
grid on;
xlabel('Frequency (Hz)');
ylabel('Phase spectrum (Rad)');
title('The phase spectrum of signal s2');
legend('The phase spectrum of signal s2');

figure(5);
subplot(211);
plot(frequency1_shifted,magnitude1_shifted);
xlabel('Frequency (Hz)');
ylabel('Magnitude spectrum (V)');
title('The magnitude spectrum of signal s1 shifted');
legend('The magnitude spectrum of signal s1 shifted');
hold on
subplot(212);
plot(frequency1_shifted,phase1_shifted);
grid on;
xlabel('Frequency (Hz)');
ylabel('Phase spectrum (Rad)');
title('The phase spectrum of signal s1 shifted');
legend('The phase spectrum of signal s1 shifted');

figure(6);
subplot(211);
plot(frequency2_shifted,magnitude2_shifted);
xlabel('Frequency (Hz)');
ylabel('Magnitude spectrum (V)');
title('The magnitude spectrum of signal s2 shifted');
legend('The magnitude spectrum of signal s2 shifted');
hold on
subplot(212);
plot(frequency2_shifted,phase2_shifted);
grid on;
xlabel('Frequency (Hz)');
ylabel('Phase spectrum (Rad)');
title('The phase spectrum of signal s2 shifted');
legend('The phase spectrum of signal s2 shifted');

figure(7);
subplot(211);
plot(frequency1_0pad,magnitude1_0pad);
xlabel('Frequency (Hz)');
ylabel('Magnitude spectrum (V)');
title('The magnitude spectrum of signal s1 with 0 padding');
legend('The magnitude spectrum of signal s1 with 0 padding');
hold on
subplot(212);
plot(frequency1_0pad,phase1_0pad);
grid on;
xlabel('Frequency (Hz)');
ylabel('Phase spectrum (Rad)');
title('The phase spectrum of signal s1 with 0 padding');
legend('The phase spectrum of signal s1 with 0 padding');

figure(8);
subplot(211);
plot(frequency2_0pad,magnitude2_0pad);
xlabel('Frequency (Hz)');
ylabel('Magnitude spectrum (V)');
title('The magnitude spectrum of signal s2 with 0 padding');
legend('The magnitude spectrum of signal s2 with 0 padding');
hold on
subplot(212);
plot(frequency2_0pad,phase2_0pad);
grid on;
xlabel('Frequency (Hz)');
ylabel('Phase spectrum (Rad)');
title('The phase spectrum of signal s2 with 0 padding');
legend('The phase spectrum of signal s2 with 0 padding');

figure(9);
subplot(311);
plot(w1);
xlabel('Time (s)');
ylabel('Signal');
title('The plot of window 1');
legend('The plot of window 1');
hold on
subplot(312);
plot(w2);
grid on;
xlabel('Time (s)');
ylabel('Signal');
title('The plot of window 2');
legend('The plot of window 2');
hold on
subplot(313);
plot(w3);
grid on;
xlabel('Time (s)');
ylabel('Signal');
title('The plot of window 3');
legend('The plot of window 3');

figure(10);
subplot(321);
plot(frequency_w1_0pad,magnitude_w1_0pad);
grid on
xlabel('Frequency (Hz)');
ylabel('Magnitude spectrum (Rad)');
title('The magnitude spectrum of window 1 with 0 padding');
legend('The magnitude spectrum of window 1 with 0 padding');
hold on
subplot(322);
plot(frequency_w1_0pad,phase_w1_0pad);
grid on
xlabel('Frequency (Hz)');
ylabel('Phase spectrum (Rad)');
title('The phase spectrum of window 1 with 0 padding');
legend('The phase spectrum of window 1 with 0 padding');
hold on
subplot(323);
plot(frequency_w2_0pad,magnitude_w2_0pad);
grid on
xlabel('Frequency (Hz)');
ylabel('Magnitude spectrum (Rad)');
title('The magnitude spectrum of window 2 with 0 padding');
legend('The magnitude spectrum of window 2 with 0 padding');
hold on
subplot(324);
plot(frequency_w2_0pad,phase_w2_0pad);
grid on
xlabel('Frequency (Hz)');
ylabel('Phase spectrum (Rad)');
title('The phase spectrum of window 2 with 0 padding');
legend('The phase spectrum of window 2 with 0 padding');
hold on
subplot(325);
plot(frequency_w3_0pad,magnitude_w3_0pad);
grid on
xlabel('Frequency (Hz)');
ylabel('Magnitude spectrum (Rad)');
title('The magnitude spectrum of window 3 with 0 padding');
legend('The magnitude spectrum of window 3 with 0 padding');
hold on
subplot(326);
plot(frequency_w3_0pad,phase_w3_0pad);
grid on
xlabel('Frequency (Hz)');
ylabel('Phase spectrum (Rad)');
title('The phase spectrum of window 3 with 0 padding');
legend('The phase spectrum of window 3 with 0 padding');

figure(11);
subplot(211);
plot(t,sig1_w3);
grid on;
xlabel('Time (s)');
ylabel('Signal (V)');
title('The signal s1 with window 3 applied');
legend('The signal s1 with window 3 applied');
subplot(212);
plot(t,sig2_w3);
grid on;
xlabel('Time (s)');
ylabel('Signal (V)');
title('The signal s2 with window 3 applied');
legend('The signal s2 with window 3 applied');

figure(12);
subplot(221);
plot(frequency1_w3_0pad,magnitude1_w3_0pad);
grid on
xlabel('Frequency (Hz)');
ylabel('Magnitude spectrum (Rad)');
title('The magnitude spectrum of sig1 with w3 with 0 padding');
legend('The magnitude spectrum of sig1 with w3 with 0 padding');
hold on
subplot(222);
plot(frequency1_w3_0pad,phase1_w3_0pad);
grid on
xlabel('Frequency (Hz)');
ylabel('Phase spectrum (Rad)');
title('The phase spectrum of sig1 with w3 with 0 padding');
legend('The phase spectrum of sig1 with w3 with 0 padding');
hold on
subplot(223);
plot(frequency2_w3_0pad,magnitude2_w3_0pad);
grid on
xlabel('Frequency (Hz)');
ylabel('Magnitude spectrum (Rad)');
title('The magnitude spectrum of sig2 with w3 with 0 padding');
legend('The magnitude spectrum of sig2 with w3 with 0 padding');
hold on
subplot(224);
plot(frequency2_w3_0pad,phase2_w3_0pad);
grid on
xlabel('Frequency (Hz)');
ylabel('Phase spectrum (Rad)');
title('The phase spectrum of sig2 with w3 with 0 padding');
legend('The phase spectrum of sig2 with w3 with 0 padding');

figure(13);
subplot(221);
plot(sig_test);
grid on
xlabel('Time(s)');
ylabel('Signal');
title('The test signal');
legend('The test signal');
hold on
subplot(222);
plot(sig_test_w3);
grid on
xlabel('Time(s)');
ylabel('Signal');
title('The test signal with w3');
legend('The test signal w3');
hold on
subplot(223);
plot(frequency_test_w3_0pad,magnitude_test_w3_0pad);
grid on
xlabel('Frequency (Hz)');
ylabel('Magnitude spectrum (Rad)');
title('The magnitude spectrum of test sig with w3 with 0 padding');
legend('The magnitude spectrum of test sig with w3 with 0 padding');
hold on
subplot(224);
plot(frequency_test_w3_0pad,phase_test_w3_0pad);
grid on
xlabel('Frequency (Hz)');
ylabel('Phase spectrum (Rad)');
title('The phase spectrum of test sig with w3 with 0 padding');
legend('The phase spectrum of test sig with w3 with 0 padding');