%% Traditional RDA imaging algorithm with CD data by XuXinbo in 2018.1
clear all;
close all;
%% 物理常量
c = 2.9979e+8; 
%% 雷达参数
global mradar
                %PRF       %fc,      kr,       tr,     fr
mradar = radar(1256.98,5.300e+9,0.72135e+12,41.75e-6,32.317e+6);
B = mradar.kr*mradar.tr
T = 1/mradar.PRF
%% 成像参数
r0  = 0.0065956*c/2; 
vm = 7062;
kd = 2*vm^2*mradar.fc/c/r0
%% 回波数据（已去载频）
CDdata = load('CDdata1.mat');
sr=CDdata.data;
%% 匹配滤波
[N,M] = size(sr);
m=1:1:M;
t=(-M/2+m)./mradar.fr;
sref=exp(-1j*pi*mradar.kr*t.^2);
result = matchfilter(sr,sref,0);
figure,imagesc(abs(result))
%% 方位向匹配滤波
% srf = exp(-2*pi*1j*0.5*kd*srftm.^2+2*pi*1j*fdc*srftm);
% HRRPSZ = [zeros(floor(fsfd*acclong/2),size(HRRPSout,2));HRRPSout];
% sarimage = matchfilter(HRRPSZ,srf,1);
%  figure;plot(1/fsfd*(1:size(sarimage,1))*vm,abs(sarimage(:,432)))
%  sarscreen = sarimage(1:size(HRRPS,1),:);
%  figure;imagesc(c*t(1:size(HRRPSout,2))/2,tmf,abs(HRRPSout));xlabel('距离/m');ylabel('tm');
% figure;imagesc(c*t(1:size(HRRPS,2))/2,1/fsfd*(1:size(sarscreen,1))*vm,abs(sarscreen));xlabel('距离/m');ylabel('方位/m');
%---------------azimuth compression
n=1:1:N;
tm=(-N/2+n)./mradar.PRF;
delta = c/2/mradar.fr;
ka=2*vm^2*mradar.fc/c/(r0+(1024+970-1)*delta);
% ref2=exp(-1j*pi*ka*tm.^2);
% REF2=conj(fftshift(fft(ref2,N)).*hamming(N).');   %用时域匹配函数FFT匹配滤波最终结果不对
% azimuth=iftx(ftx(range).*(REF2.'*ones(1,M)));
fa=-mradar.PRF/2+mradar.PRF*(n-1)/N;
ref2=exp(-1j*pi*fa.^2./kd);
azimuth=ifft(fft(result).*(ref2.'*ones(1,M)));       %直接写出频域形式结果正确
% azimuth=ifft(fft(range).*(REF2.'*ones(1,M)));
image=mat2gray(abs(azimuth));
image=image*8*1;
imwrite(image,'SAR_test.jpg','JPG');
figure,imagesc(abs(azimuth))
