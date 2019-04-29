classdef radar
    %雷达对象
    properties
        PRF ;
        fc;
        kr;
        tr;
        fr;
    end
    methods
        function obj = radar(PRF,fc,kr,tr,fr)
            %构造此类的实例
            % 此处显示详细说明
            obj.fc = fc;
            obj.PRF = PRF;
            obj.kr = kr;
            obj.tr = tr;
            obj.fr = fr;
        end
    end
end

