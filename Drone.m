classdef Drone
    %DRONE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Id
        Range
        X_coord
        Y_coord
    end
    
    methods
        function obj = Drone(id, range, x, y)
            %DRONE Construct an instance of this class
            %   Detailed explanation goes here
            obj.Id = id;
            obj.Range = range;
            obj.X_coord = x;
            obj.Y_coord = y;
        end
        
        function nextMove = selectMove(obj, dest_x, dest_y)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            
            % Move East
            if obj.X_coord - dest_x < 0
                obj.X_coord = obj.X_coord + 1;
                
            % Move West
            elseif obj.X_coord - dest_x > 0
                obj.X_coord = obj.X_coord - 1;
                
            % Move North
            elseif obj.Y_coord - dest_y < 0
                obj.Y_coord = obj.Y_coord + 1;
                
            % Move South
            elseif obj.Y_coord - dest_y > 0
                obj.Y_coord = obj.Y_coord - 1;
                
            end
            
            nextMove = obj;
        end
        
        
        function x_coord = getX(obj)
            x_coord = obj.X_coord;
        end
        
        function y_coord = getY(obj)
            y_coord = obj.Y_coord;
        end
    end
end

