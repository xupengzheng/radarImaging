function signal = s(t)
%S 此处显示有关此函数的摘要
%   此处显示详细说明
global mradar;
 signal = a(t,mradar.tr).*exp(1i*2*pi*(mradar.fc*t+0.5*mradar.kr*t.^2));
% signal = a(t,mradar.tr).*exp(1i*2*pi*(0.5*mradar.kr*t.^2));
end

