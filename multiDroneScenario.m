% Initialisation of time and cost
time = 0;
cost = 0;

% Base Station coordinates
base_x = 0;
base_y = 0;

% Drone intial properties
drone_range = 2;
drone_x = 0;
drone_y = 0;
id = 1;

% Create objects of Destination, BaseStation and Drone
baseStation = BaseStation(base_x, base_y);
%drone1 = Drone(id, drone_range, drone_x, drone_y);

% Generate random destination points
rng(0,'threefry');
rand_x = randi([-10 10],1,10);
rand_y = randi([-10 10],1,10);

listOfDestinations = {};
for i = 1:10
    destination = Destination(rand_x(i), rand_y(i));
    listOfDestinations{i} = destination;
end

listOfDrones = {};

% Add the newly created drone object into the list of drones
listOfDrones{1} = Drone(id, drone_range, drone_x, drone_y);
num_of_drones = 1;

figure
% Store Base Station graph type, used for legend
bs_plot = plot(baseStation.X_coord, baseStation.Y_coord, 'o', 'MarkerFaceColor','b');
grid on
hold on
% Store Drone path graph type, used for legend
drone_path = plot([drone1.X_coord drone1.X_coord], [drone1.Y_coord drone1.Y_coord], 'r--', 'LineWidth', 2);
hold on
for i = 1:length(listOfDestinations)
    % Store Visited node destinations graph type, used for legend
    visited_dest_plot = plot(listOfDestinations{i}.X_coord, listOfDestinations{i}.Y_coord, 'd', 'Color', 'black', 'MarkerFaceColor', 'g');
    % Store Visited node destinations graph type, used for legend
    unvisited_dest_plot = plot(listOfDestinations{i}.X_coord, listOfDestinations{i}.Y_coord, 'd', 'Color', 'g', 'MarkerFaceColor', 'w');
    hold on
end

% Add legend to the graph
legend([bs_plot, visited_dest_plot, unvisited_dest_plot, drone_path], {'Base Station', 'Visited Destinations', 'Unvisited Destinations', 'Drone Path'},'AutoUpdate','off', 'Location', 'best');

% Add Base station to the end of the list, for the drone to return
%listOfDestinations{end+1} = baseStation;


% Loops until the drone has reached the destination
while (~isempty(listOfDestinations)) && ~(listOfDrones{1}.X_coord == listOfDestinations{1}.X_coord && listOfDrones{1}.Y_coord == listOfDestinations{1}.Y_coord)
    
    % Calculate the Manhattan Distance between the last drone in the list and the base station
	manh_dist_drone_base = abs(listOfDrones{1}.X_coord - baseStation.X_coord) + abs(listOfDrones{end}.Y_coord - baseStation.Y_coord);
    
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
	manh_dist_drone_dest = abs(listOfDrones{1}.X_coord - listOfDestinations{1}.X_coord) + abs(listOfDrones{1}.Y_coord - listOfDestinations{1}.Y_coord);
    
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
                      %return
                   end
                end
                     
            end
        end
    end
    
    lenOfList = length(listOfDrones);
    % Update coordinates of the drones
    for i = 1:lenOfList
         if i == lenOfList
            listOfDrones{end} = listOfDrones{end}.selectMove(listOfDestinations{1}.X_coord, listOfDestinations{1}.Y_coord);
         else
            listOfDrones{i} = listOfDrones{i}.selectMove(listOfDestinations{1}.X_coord, listOfDestinations{1}.Y_coord);
         end
        
    end
    
   
    if (drone1.X_coord == listOfDestinations{1}.X_coord && drone1.Y_coord == listOfDestinations{1}.Y_coord)
        disp("Destination reached");
        % Remove the first visited destination
        listOfDestinations = listOfDestinations(2:end);
    end
    
    % Increase time elapsed and cost based on the number of drones currently in use
	time = time + 1;
	cost = cost + 5 * num_of_drones;
    
end