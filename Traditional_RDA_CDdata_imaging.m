%% Traditional RDA imaging algorithm with CD data by XuXinbo in 2018.1
%---------------CD data parameters
tic
clc,clear,home
PRF             = 1256.98;       % Pulse Reputation Frequency (Hz)
Fr              = 32.317e+6;     % Radar sampling rate (Hz)
f0              = 5.300e+9;      % Radar center frequency (Hz)
c               = 2.9979e+8;     % Speed of light (m/s)
R0              = 0.0065956*c/2; % Slant range of first radar sample (m)
Nrepl           = 1349;          % No. of valid samples in the replica
Kr              = 0.72135e+12;   % FM rate of radar pulse (Hz/s)
Tr              = 41.75e-6;      % Chirp duration (s)
vr              = 7062;
delta           = c/2/Fr;
wavelen         = c/f0;
CDdata = load('C:\Users\XUXINBO\Documents\MATLAB\CD_SAR\EXTRACTED_DATA\CDdata1.mat');
data=CDdata.data;
%---------------range compression
[N,M] = size(data);
m=1:1:M;
t=(-M/2+m)./Fr;
ref=exp(-1j*pi*Kr*t.^2);
REF=conj(fftshift(fft(ref)).*hamming(M).');
range=ifty(fty(data).*(ones(N,1)*REF));
figure,imagesc(abs(range))
%---------------azimuth compression
n=1:1:N;
tm=(-N/2+n)./PRF;
ka=2*vr^2/wavelen/(R0+(1024+970-1)*delta);
% ref2=exp(-1j*pi*ka*tm.^2);
% REF2=conj(fftshift(fft(ref2,N)).*hamming(N).');   %用时域匹配函数FFT匹配滤波最终结果不对
% azimuth=iftx(ftx(range).*(REF2.'*ones(1,M)));
fa=-PRF/2+PRF*(n-1)/N;
ref2=exp(-1j*pi*fa.^2./ka).*hamming(N).';
azimuth=ifft(fft(range).*(ref2.'*ones(1,M)));       %直接写出频域形式结果正确
% azimuth=ifft(fft(range).*(REF2.'*ones(1,M)));

image=image*8*1;
imwrite(image,'SAR_test.jpg','JPG');
figure,imagesc(abs(azimuth))
