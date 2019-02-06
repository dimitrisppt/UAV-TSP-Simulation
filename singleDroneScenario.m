% Initialisation of time and cost
time = 0;
cost = 0;

initial_x = 0;
initial_y = 0;
num_stops = 50;

% Base Station coordinates
base_x = initial_x;
base_y = initial_y;

% Drone intial properties
drone_range = 2;
drone_x = initial_x;
drone_y = initial_x;
id = 1;

% Create objects of Destination, BaseStation and Drone
baseStation = BaseStation(initial_x, initial_y);
drone1 = Drone(id, drone_range, drone_x, drone_y);

% Generate random destination points 
% rng(0,'threefry');
% rand_x = randi([-10 10],1,10);
% rand_y = randi([-10 10],1,10);
% arrayy = {[-13,8],[-14,14],[-16,17],[-19,6],[-21,9],[-23,8],[-28,4],[-26,3],[-26,-6]};

listOfDestinations = {};
tours = matlabTSP(num_stops, base_x, base_y);
length(tours)

for i = 1:length(tours)
    dest_x = tours(i, 1);
    dest_y = tours(i, 2);
    destination = Destination(dest_x, dest_y);
    listOfDestinations{i} = destination;
end


listOfDrones = {};

% Add the newly created drone object into the list of drones
listOfDrones{1} = drone1;
num_of_drones = 1;

title('Single Drone Path - TSP (2-OPT)');
grid on
set(gca,'Xtick',-10 : 1 : 10); %sets the numbered ticks 1 apart
set(gca,'Ytick',-10 : 1 : 10); %same as above

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
% Store Base Station graph type, used for legend
bs_plot = plot(baseStation.X_coord, baseStation.Y_coord, 'o', 'MarkerFaceColor','b');

% Add legend to the graph
legend([bs_plot, visited_dest_plot, unvisited_dest_plot, drone_path], {'Base Station', 'Visited Destinations', 'Unvisited Destinations', 'Drone Path'},'AutoUpdate','off', 'Location', 'best');

% Add Base station to the end of the list, for the drone to return
listOfDestinations{end+1} = baseStation;

% Loops until the drone has reached the destination
while (~isempty(listOfDestinations)) && ~(drone1.X_coord == listOfDestinations{1}.X_coord && drone1.Y_coord == listOfDestinations{1}.Y_coord)
    % Store previous coordinates, used to plot the graph
    prev_x = drone1.X_coord;
    prev_y = drone1.Y_coord;
    % Move drone
    drone1 = drone1.selectMove(listOfDestinations{1}.X_coord, listOfDestinations{1}.Y_coord);
    cost = cost + 5;
    time = time + 1;
    if (drone1.X_coord == listOfDestinations{1}.X_coord && drone1.Y_coord == listOfDestinations{1}.Y_coord)
        plot(listOfDestinations{1}.X_coord, listOfDestinations{1}.Y_coord, 'd', 'Color', 'black', 'MarkerFaceColor', 'g');
    end
    % Connect with a line the previous coordinates with the new coordinates
    line([prev_x drone1.X_coord], [prev_y drone1.Y_coord], 'Color', 'w');
    plot([prev_x drone1.X_coord], [prev_y drone1.Y_coord], 'r--', 'LineWidth', 2);
    disp(['Drone coords (', num2str(drone1.X_coord),',' num2str(drone1.Y_coord), ')']);
    pause(0.1)
    if (drone1.X_coord == listOfDestinations{1}.X_coord && drone1.Y_coord == listOfDestinations{1}.Y_coord)
        if drone1.X_coord == baseStation.X_coord && drone1.Y_coord == baseStation.Y_coord 
            disp("Returned back to Base Station"); 
            plot(baseStation.X_coord, baseStation.Y_coord, 'o', 'MarkerFaceColor','b');
        else 
            disp("Destination reached");
        end
        % Remove the first visited destination
        listOfDestinations = listOfDestinations(2:end);
    end
end

disp(['Total cost: ', num2str(cost)]);
disp(['Time elapsed: ', num2str(time)]);
