%% Seance 1

%% constants
fa = 1/(100000);
fe = 1/(5000);
number_of_points = 1500;

%quantization step
q = 0.5;

% frequencies
w1 = 2*pi*300;
w2 = 2*pi*500;
w3 = 2*pi*400;

% random phases from 0 to pi
ph1 = pi*rand;
ph2 = pi*rand;
ph3 = pi*rand;

% make 1500 points of time for later plotting
t = (0 : fa : (number_of_points - 1)*fa);
td = (0 : fe : (number_of_points - 1)*fa);
th = (0 : fe/2 : (number_of_points - 1)*fa);

% the waves
sig = sin(w1*t + ph1) + 2*sin(w2*t + ph2) + 3*sin(w3*t + ph3);
sigd = sin(w1*td + ph1) + 2*sin(w2*td + ph2) + 3*sin(w3*td + ph3);
sigd_held = Hold_B0(sigd, 2);
sigq = q*round(sig/q);
sigq_error = sig - sigq;
sigd_h_q = q*round(sigd_held/q);

% plotting the signals
subplot(241);
plot(t, sig);
grid on;
xlabel('Time (s)');
ylabel('Signal (V)');
title('The continuous signal');
legend('The continuous signal');
hold on

subplot(242);
stem(td, sigd);
grid on;
xlabel('Time (s)');
ylabel('Signal (V)');
title('The discretized signal');
legend('The discretized signal');
hold on

subplot(243);
plot(th, sigd_held);
grid on;
xlabel('Time (s)');
ylabel('Signal (V)');
title('The discretized signal when held');
legend('The discretized signal when held');
hold on

subplot(244);
plot(t, sigq);
grid on;
xlabel('Time (s)');
ylabel('Signal (V)');
title('The quantized signal');
legend('The quantized signal');
hold on

subplot(245);
plot(t, sigq_error);
grid on;
xlabel('Time (s)');
ylabel('Signal (V)');
title('The quantization error signal');
legend('The quantization error signal');

variances = zeros(1, 16);
q_test = zeros(1, 16);
for i = 1 : 16
    q_test(i) = (0.5)^(i-2);
    variance(i) = var(sig - q_test(i)*round(sig/q_test(i)));
end

subplot(246);
loglog(q_test, variance);
grid on;
xlabel('Log of q');
ylabel('Log of variance');
title('The linearity between Log q & Log variance');
legend('Log variance vs. Log q');

% To make the Butterworth and find its characteristics
[B,A] = butter(2,2*2000/100000);
[hcont,f]=freqz(B,A,1024,100000);
sig_recovered = filter(B, A, sigd_h_q);

subplot(247);
plot(f,abs(hcont));
grid on;
xlabel('f');
ylabel('abs(hcont)');
title('The linearity characteristics of Butterworth');
legend('abs(hcont) vs. f');

subplot(248);
plot(th, sig_recovered);
grid on;
xlabel('Time (s)');
ylabel('Signal (V)');
title('The recovered signal');
legend('The recovered signal');