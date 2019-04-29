classdef platform
    %飞行平台
    properties
        v;
        h;
        angle;
        R0;
    end
    methods
        function obj = platform(v,R0)
            %构造此类的实例
            % 此处显示详细说明
            obj.v = v;
            obj.R0 = R0;
            obj.h = 5000;
            obj.angle = 1.1071;
        end
    end
end
