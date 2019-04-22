classdef platform
    %飞行平台
    properties
        v;
        h;
        angle;
    end
    methods
        function obj = radar()
            %构造此类的实例
            % 此处显示详细说明
            obj.fc = 1*10^9;
            obj.PRF = 57.6;
            obj.kr = 6*10^12;
            obj.tr = 5*10^-6;
        end
    end
end
