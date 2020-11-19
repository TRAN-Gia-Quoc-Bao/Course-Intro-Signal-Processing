%% Signal processing - Discrete Filters

%% Default commands
close all;
clear all;
clc;

%% Constants
f0 = 150; % Cut frequency at -3dB
fs = 1280;
fc = 150;
N = 60;
N1 = 9;
N2 = 51;

%% I. Analysis of digital filters

[magnitude1 phase1 frequency1] = FilterVisu('Filter 1', [1 0 0], [1 -0.4 0.6], 100, fs);
[magnitude2 phase2 frequency2] = FilterVisu('Filter 2', [1 0 1], [1 0 0.81], 100, fs);
[magnitude3 phase3 frequency3] = FilterVisu('Filter 3', [1 1 1], [1 0 0], 100, fs);

%% II. FIR filter - Windows method
%% 1. Elementary synthesis
lo = f0/fs;
N = 200;
n = [-N/2:1:N/2];
N1 = 9;
N2 = 51;
n1 = [0:1:N1-1];
n2 = [0:1:N2-1];

Hidn = 2*lo*sinc(2*pi*lo*n);
h1n = 2*lo*sinc(2*pi*lo*(n1-(N1-1)/2));
h2n = 2*lo*sinc(2*pi*lo*(n2-(N2-1)/2));

figure(1)
subplot(3,1,1)
plot(n, Hidn);
title('Impulse response hid(n)')
subplot(3,1,2)
plot(n1, h1n);
title('Impulse response h1(n)')
subplot(3,1,3)
plot(n2, h2n);
title('Impulse response h2(n)')

%%
figure(2)
[Modu1,Phse1,Fr1] = FilterVisu('Hidn',Hidn,1,512,fs);
figure(3)
[Modu2,Phse2,Fr2] = FilterVisu('h1n',h1n,1,512,fs);
figure(4)
[Modu3,Phse3,Fr3] = FilterVisu('h2n',h2n,1,512,fs);
% The more points in the window, the more the filter corresponds to the ideal filter


%% 2. Influence of the choice of windows and calculation of the order

fen = window(@hann,N2);
Hnfen = h2n'.*fen;   
figure(5)
[Modfen,Phsfen,Ffen] = FilterVisu('Hnfen',Hnfen,1,512,fs);

% Calculation of the minimum value of n

Deltaf=0.02;
Nmin=abs(3.1/Deltaf);

%% 3. Transposition of filters

Hph=-h2n;
Hph((N2+1)/2)=1-h2n((N2+1)/2);
figure(6)
[Modph,Phsph,Fph] = FilterVisu('Hph',Hph,1,512,fs);

Hphfen=Hph'.*fen;
figure(7)
[Modphfen,Phsphfen,Fphfen] = FilterVisu('Hphfen',Hphfen,1,512,fs);

%% III. RIF filters: comparison of methods

%% 1. Windows method

f01=150;
f02=300;
Deltaf=20;
ondmax=20*log(0.01);
lo1=f01/fs;
lo2=f02/fs;
DeltaFnorm=Deltaf/fs;
M=round(3.1/DeltaFnorm);
Hnf1=fir1(M,2*[lo1 lo2]);
figure(8)
% create a band-pass filter 
[Modf1,Phsf1,Ff1]=FilterVisu('Hnf1',Hnf1,1,512,fs); % create a band-pass filter 

%% 2. Minimax method
f1=f01-(Deltaf/2);
f2=f01+(Deltaf/2);
f3=f02-(Deltaf/2);
f4=f02+(Deltaf/2);
F=[f1 f2 f3 f4];
A=[0 1 0];
DEV=0.01*[1 1 1];
[m,f0,ao,w]=firpmord(F,A,DEV,fs);
Hnf2=firpm(m,f0,ao,w);
figure(9)
[Modf2,Phsf2,Ff2]=FilterVisu('Hnf2',Hnf2,1,512,fs);

%% 5. Comparison

figure(10)
subplot(2,1,1)
plot(Ff1,20*log10(Modf1),'r',Ff2,20*log10(Modf2),'b')
legend('fen','pm');
subplot(2,1,2)
plot(Ff1,Phsf1,'r',Ff2,Phsf2,'b')
legend('fen','pm');

%% IV. Synthesis of RII filters

%% 1. Low-pass filter : bilinear transformation method

% Second order low pass filter
d = 1/(2*pi*f0); % denoted by p the transfer function variable
H1p = tf([1],[d.^2 sqrt(2)*d 1]);
z = roots(H1p.num{1});
p = roots(H1p.den{1});
figure(11)
plot(p,'*');

ff = (0:1/4096:1)*2*fs;
ww = ff*2*pi;
[Hp,W] = freqs(H1p.num{1},H1p.den{1},ww);
Habs = abs(Hp);
figure(12)
plot(ff,Habs);
title('Réponse en fréquence de H1p');

% Bilinear transformation

f0tilde = fs/pi*tan(pi*f0/fs); % new frequency taking into account the distortion
dd = 1/(2*pi*f0tilde); % new variable p of the transfer function
H1ptilde = tf([1],[dd.^2 sqrt(2)*dd 1]);
H1z = c2d(H1ptilde,1/fs,'tustin');

fa = (0:1/4096:1)*2*fs;
fd = fs/pi*atan(pi*fa/fs);
figure(13)
plot(fa,fd);
title('Digital frequency fd as a function of analog frequency fa')
xlabel('fa')
ylabel('fd')

figure(14)
zplane(H1z.num{1},H1z.den{1});

[Hz,F] = freqz(H1z.num{1},H1z.den{1},ff,fs);
figure(15)
plot(F,abs(Hz),'r'); % compressed and periodized
hold on 
plot(ff,Habs,'b');

% For the cutoff frequency, we notice that the predistortion allowed
% to keep the good value for -3dB. In discrete, the response is compressed to
% enter the frequency band 0: fe / 2 which is not the case continuously. In addition, it is periodic.
%% V. Digital filters : comparison

% High-pass filters with
fc = 100;
fp = 130;
de = 0.01;
df = fp - fc;
fo = (fc+fp)/2;

%% 1. RIF filters

% Windows method

M = 3.1*fs/df-1;    % Determining the filter order
N = 132;
B = fir1(N,2*fo,'high');
FiltreVisu('Windows method',B,1,512,fs);

% Minimax method

[N,Fo,Ao,W] = firpmord([fc fp],[0 1],[de de],fs);
b = firpm(N,Fo,Ao,W);   %N=84
FiltreVisu('Minimax method',b,1,512,fs);

%% 2. IIR filters

% Butterworth

[N, Wn] = buttord(2*fp/fs, 2*fc/fs,-20*log10(1-de),-20*log10(de));
[b,a] = butter(N,Wn,'high'); %N=24
FilterVisu('Butterworth',b,a,512,fs);

% Elliptic

[N, Wp] = ellipord(2*fp/fs, 2*fc/fe,-20*log10(1-de),-20*log10(de));
[B,A] = ellip(N,-20*log10(1-de),-20*log10(de),2*fp/fs,'high');
FilterVisu('Elliptic',B,A,512,fs); %N=6

%% Comparison

% Between the two RIF filters, the one with the window method is more
% precise but at a higher order (132 >> 84). This is why we observe
% of larger ripples in the frequency response of the filter
% with the minimax method, but which remain below 1%
% Between the two RII filters, we observe that the frequency response
% oscillates more for the elliptical filter than for the butterworth. This is
% due to the very lower order of the elliptical filter.

% On the other hand, even if the RII filters have weak orders, allowing
% less calculations, they have a phase in the bandwidth
% nonlinear, very distorted for the elliptical filter, implying a
% signal distortion.

% Between FIR and IIR filters, we see that:

% For FIR filters: it is always stable, which is good. Also it has linear
% phase, so it is convenient if we want to predict its behaviour at
% different frequencies. But it may require a lot of coefficients.

% For IIR filters: it is the opposite of FIR in terms of characteristics.
