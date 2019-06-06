clear all;
close all;
%% 物理常量
c = 2.9979e+8; 
%% 雷达参数
global mradar;
                 %PRF     %fc,      kr,       tr,     fr  皆为标准单位
mradar = radar(1256.98,5.300e+9,0.72135e+12,41.75e-6,6*32.317e+6);
B = mradar.kr*mradar.tr
RangeResolution = c/(2*B)
T = 1/mradar.PRF
%% 成像距离
r0 =50e3;
%% 成像场景
dx = 10;  %x像素间距10m
dy = 10;  %y像素间距10m
% screen = [0 0 0 0 0
%           0 0 0 0 0
%           0 0 0 0 1 ;
%           0 0 0 0 0;
%           0 0 0 0 0;]
screen = [0 0 1 0 0
          0 0 1 0 0
          1 1 0 1 1 ;
          0 1 0 1 0;
          0 0 1 0 0;]
imwrite(1-screen,'screen.bmp','bmp');
figure;imshow(mat2gray(abs(1-screen)));title('成像场景');

%% 回波仿真
t = 0:1/(mradar.fr):T;
[row,col] = size(screen);
centerx = (col+1)/2;
centery = (row+1)/2;
HRRPS = [];
thetagap = 0.01;
thetasweep = 0 :thetagap :3;
for theta = thetasweep  %不同角度
st = s(t);
sr = zeros(size(t));
    for ii = 1:col
        for jj = 1:row
            x =  (ii-centerx)*dx;
            y = -(jj-centery)*dy;
            x = x*cosd(theta)-y*sind(theta);
            y = y*cosd(theta)+x*sind(theta);
            d = sqrt(y^2+(r0+x)^2);
            sr = sr + screen(jj,ii)*s(t-2*d/c);
        end
    end
    if theta==0
    figure;plot(t,real(st));legend('发射信号');hold on;plot(t,real(sr),'--r','DisplayName','接收信号');title('发射与接收信号实部');xlabel('时间/s');
    end
%% 去载频
    sc = exp(-1i*2*pi*(mradar.fc*t));
    st = st.*sc;
%% 参考信号加窗
    Nz = length(find(st~=0));
    win = taylorwin(Nz);
    for ii = 1:Nz
        st(ii) = st(ii)*win(ii);
    end
%%%%%%%%%%%%%%%%%
    sr = sr.*sc;
    if theta==0
    figure;plot(t,real(st),t,real(sr),'r');title('去载频后发射和接收信号');
    end
%% 匹配滤波
    result = matchfilter(sr,st,0);
    %result = dechirp(sr,st,r0);
    result = result*pi/max(abs(result));
    dr =100;
    [~,indexlb] = min(abs((r0-dr)*2/c-t));
    [~,indexub] = min(abs((r0+dr)*2/c-t));
    indexrange = indexlb:indexub;
    figure;plot(c*t(indexrange)/2,abs(result( indexrange)));xlabel('距离/m');ylabel('HRRP幅度');title([num2str(theta) '度匹配滤波结果幅度即HRRP']);
    HRRPS = [HRRPS;abs(result( indexrange))];
    %figure;plot(angle(result));title([num2str(theta) '度匹配滤波结果相位']);
end
figure;imagesc(c*t(indexrange)/2,thetasweep,HRRPS);xlabel('距离/m');ylabel('theta');

% for theta = thetasweep  %不同角度
%     figure;plot(c*t(indexrange)/2,HRRPS(theta/thetagap+1,:));title([num2str(theta) '度HRRP']);
% end