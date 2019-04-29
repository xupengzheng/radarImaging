function result = tm_compress(sig1,srf)
%×İÏòÆ¥ÅäÂË²¨
% 
n1 = size(sig1,1);
n2 = size(srf,1);
fftnum = n1;
fftsrf = conj(fft(srf,fftnum));
for ii = 1:size(sig1,2)
    fftsig1i = fft(sig1(:,ii),fftnum);
    sig1(:,ii) = ifft(fftsig1i.*fftsrf);
end
result = sig1;

ghj
end
