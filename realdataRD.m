clear all;
%close all;
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
[N,M] = size(sr);
%% 匹配滤波
t = 0:1/mradar.fr:mradar.tr;
sref = exp(-1j*pi*mradar.kr*t.^2);
result = matchfilter(sr,sref,0);
figure,imagesc(abs(result));
%graymap = gray; colormap(graymap(end:-1:1,:));
%% 方位向匹配滤波
n=1:1:N;
tm=(-N/2+n)./mradar.PRF;
%%在时域操作，斜视角未知，多普勒中心频率未知，无法时域操作
% sref2=exp(1j*pi*kd*tm.^2);
% azimuth= matchfilter(result,sref2,1);
%%在频域操作，使频域函数覆盖整个频率范围，从而覆盖实际信号所在
fa=-mradar.PRF/2+mradar.PRF*(n-1)/N;
ref2=exp(-1j*pi*fa.^2./kd);
azimuth=ifft(fft(result).*(ref2.'*ones(1,M)));       
%% 成像结果
image=mat2gray(abs(azimuth));
image=image*8*1;
imwrite(image,'SAR_RD.jpg','JPG');
figure,imagesc(abs(azimuth));
%graymap = gray;colormap(graymap(end:-1:1,:));
