% Initialisation of time and cost
time = 0;
cost = 0;

% Base Station coordinates
base_x = 0;
base_y = 0;

% Destination coordinates 
dest_x = 10;
dest_y = 0;

% Drone intial properties
drone_range = 2;
drone_x = 0;
drone_y = 0;
id = 1;

% Create objects of Destination, BaseStation and Drone
destination = Destination(dest_x, dest_y);
baseStation = BaseStation(base_x, base_y);
drone1 = Drone(id, drone_range, drone_x, drone_y);

listOfDrones = {};

% Add the newly created drone object into the list of drones
listOfDrones{1} = drone1;
num_of_drones = 1;

figure


% Repeats until the first drone can establish communication with the destination
while listOfDrones{1}.X_coord < destination.X_coord
    
    % Calculate the Manhattan Distance between the last drone in the list and the base station
	manh_dist_drone_base = abs(listOfDrones{end}.X_coord - baseStation.X_coord) + abs(listOfDrones{end}.Y_coord - baseStation.Y_coord);

    % When the drone cannot connect with the base due to its range limitation, send a relay drone
    if manh_dist_drone_base >= drone_range 
        num_of_drones = num_of_drones + 1;
        % Create a new Drone object with dynamic name
        id = id + 1;
        eval(['drone', int2str(num_of_drones),' = Drone(id, drone_range, drone_x, drone_y);']);      
        listOfDrones{end+1} = eval(['drone', int2str(num_of_drones)]);
        disp(['Sending new drone (No.', num2str(listOfDrones{end}.Id), ')']) 
    end
    
    % Calculate the Manhattan Distance between the first drone and the destination
	manh_dist_drone_dest = abs(listOfDrones{1}.X_coord - destination.X_coord) + abs(listOfDrones{1}.Y_coord - destination.Y_coord);
    
    % The drone is too far from destination and cannot establish a connection
    if manh_dist_drone_dest > drone_range
    	disp(['Drone', num2str(listOfDrones{1}.Id), ' cannot establish connection with destination. ', 'Total Cost: ', num2str(cost), ' Time elapsed: ', num2str(time)])
    
    % Destination is in drone's range and can now establish a connection
    else
    	disp(['Drone', num2str(listOfDrones{1}.Id), ' established connection with destination. ', 'Total Cost: ', num2str(cost), ' Time elapsed: ', num2str(time)])
        len = length(listOfDrones);
        for i = 1:len
            if i <= len-1
                drone_i = listOfDrones{i};
                drone_j = listOfDrones{i+1};
                
                % Distance between drones
                manh_dist_drone_i_drone_j = abs(drone_i.X_coord - drone_j.X_coord) + abs(drone_i.Y_coord - drone_j.Y_coord);
                
                % Distance between last drone and base
                manh_dist_drone_j_base = abs(drone_j.X_coord - baseStation.X_coord) + abs(drone_j.Y_coord - baseStation.Y_coord);
                
                if manh_dist_drone_i_drone_j <= drone_range
                   disp(['Drone', num2str(drone_i.Id), ' transmitting data to Drone', num2str(drone_j.Id), '. Total Cost: ', num2str(cost), ' Time elapsed: ', num2str(time)])
                   if manh_dist_drone_j_base <= drone_range
                      disp(['Drone', num2str(drone_j.Id), ' transmitting data to the Base Station', '. Total Cost: ', num2str(cost), ' Time elapsed: ', num2str(time)])
                      % Call return to prevent the base station from sending a new drone
                      return
                   end
                end
                     
            end
        end
    end
    
    lenOfList = length(listOfDrones);
    % Update coordinates of the drones
    for i = 1:lenOfList
         plot([listOfDrones{end}.X_coord listOfDrones{i}.X_coord], [listOfDrones{i}.Y_coord listOfDrones{i}.Y_coord], 'r--', 'LineWidth', 2);
         if i == lenOfList
            listOfDrones{end}.X_coord = listOfDrones{end}.X_coord + 1;
         else
             listOfDrones{i}.X_coord = listOfDrones{i}.X_coord + 1;
         end
        
    end
    
    % Increase time elapsed and cost based on the number of drones currently in use
	time = time + 1;
	cost = cost + 5 * num_of_drones;
     
end


