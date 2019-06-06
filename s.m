function signal = s(t)
% 产生雷达发射的信号
%   
global mradar;
 signal = a(t,mradar.tr).*exp(1i*2*pi*(mradar.fc*t+0.5*mradar.kr*t.^2));
% signal = a(t,mradar.tr).*exp(1i*2*pi*(0.5*mradar.kr*t.^2));
end

