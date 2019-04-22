function sr_t = getsr_t()
%快时间回波数据
%
sr_t = zeros();
for ii = 1:N
    for jj = 1:M
        dis = getdistance();
        det_t = 2*dis/c;
        sr_singleP = delay_t(st,det_t);
        sr_t = sr_t + sr_singleP;
    end
end
end

