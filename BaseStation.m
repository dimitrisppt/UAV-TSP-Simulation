classdef BaseStation
    %UNTITLED5 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        X_coord
        Y_coord
    end
    
    methods
        function obj = BaseStation(x, y)
            %UNTITLED5 Construct an instance of this class
            %   Detailed explanation goes here
            obj.X_coord = x;
            obj.Y_coord = y;
        end
        
        function outputArg = method1(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.Property1 + inputArg;
        end
    end
end

