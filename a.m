function a = a(tmp,tr)
a = zeros(size(tmp));
for i = 1:size(tmp,2)
    if (tmp(i)>=0)&&(tmp(i)<=tr)
        a(i) = 1;
    else
        a(i) = 0;
    end
end
end

