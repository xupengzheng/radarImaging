function HRRPSout = rwc(HRRPS,tm,rwr)
%   距离走动校正
%  
global mradar;
c = 2.9979e+8; 
i = 1;
for t = tm
    n =floor(2*rwr*t*mradar.fr/c+0.5);
    HRRPS(i,:) = delayn( HRRPS(i,:),n);
    i = i+1;
end
  HRRPSout= HRRPS;
end

function sout = delayn(sin,n)
sout = zeros(size(sin));
for ii = 1:length(sin)
    if ii+n>=1 && ii+n<length(sout)
    sout (ii+n) = sin(ii);
    end
end
end

