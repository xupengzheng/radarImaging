clear all;
close all;
%% 雷达参数
global mradar;
mradar = radar(1256.98,5.300e+9,0.72135e+12,41.75e-6,32.317e+6);
B = mradar.kr*mradar.tr
T = 1/mradar.PRF
%% 
t = 0:1/(20*B):T;
st = s(t);
delt = 0.00065956+0.5*pi/2/pi/mradar.fc;
sr = s(t-delt);
sc = exp(-1i*2*pi*mradar.fc*t);
%% 去载频
st = st.*sc;
sr = sr.*sc;

%sr = a(t,mradar.tr).*exp(1j*2*pi*(mradar.fc*t+0.5*mradar.kr*t.^2));
figure;plot(t,real(st),t,imag(st));title('real st');hold on;plot(t,real(sr),'r');title('delay real sr');
figure;plot(t,unwrap(angle(sr)));title('angel sr');
result = matchfilter(sr,st,0);
result = result*pi/max(abs(result));
figure;plot(t,abs(result));title('匹配滤波结果');
figure;plot(real(result));hold on ;plot(imag(result),'r');plot(abs(result),'y');plot(angle(result),'g');