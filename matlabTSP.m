function sorted_tours = matlabTSP(num_stops, bs_x, bs_y)

figure;

%load('usborder.mat','x','y','xx','yy');
rng(3,'twister') % makes a plot with stops in Maine & Florida, and is reproducible
nStops = num_stops; % you can use any number, but the problem size scales as N^2
stopsLon = zeros(nStops,1); % allocate x-coordinates of nStops
stopsLat = stopsLon; % allocate y-coordinates
n = 1;
while (n <= nStops)
    if n==1
        xp = bs_x;
        yp = bs_y;
    else
        xp = randi([-10 10],1,1);
        yp = randi([-10 10],1,1);
    end
    stopsLon(n) = xp;
    stopsLat(n) = yp;
    n = n+1;
end
%plot(x,y,'Color','red'); % draw the outside border
hold on
% Add the stops to the map
plot(stopsLon,stopsLat,'*b')
grid on
set(gca,'Xtick',-10 : 1 : 10); %sets the numbered ticks 1 apart
set(gca,'Ytick',-10 : 1 : 10); %same as above
%%%%%

idxs = nchoosek(1:nStops,2);

%%%%%%
dist = hypot(stopsLat(idxs(:,1)) - stopsLat(idxs(:,2)), ...
    stopsLon(idxs(:,1)) - stopsLon(idxs(:,2)));
lendist = length(dist);

%%%%%%
Aeq = spones(1:length(idxs)); % Adds up the number of trips
beq = nStops;

%%%%%%

Aeq = [Aeq;spalloc(nStops,length(idxs),nStops*(nStops-1))]; % allocate a sparse matrix
for ii = 1:nStops
    whichIdxs = (idxs == ii); % find the trips that include stop ii
    whichIdxs = sparse(sum(whichIdxs,2)); % include trips where ii is at either end
    Aeq(ii+1,:) = whichIdxs'; % include in the constraint matrix
end
beq = [beq; 2*ones(nStops,1)];

%%%%%%

intcon = 1:lendist;
lb = zeros(lendist,1);
ub = ones(lendist,1);


%%%%%
opts = optimoptions('intlinprog','Display','off','Heuristics','round-diving',...
    'IPPreprocess','none');
[x_tsp,costopt,exitflag,output] = intlinprog(dist,intcon,[],[],Aeq,beq,lb,ub,opts);



%%%%%%
segments = find(x_tsp); % Get indices of lines on optimal path
lh = zeros(nStops,1); % Use to store handles to lines on plot
lh = matlabUpdatePlot(lh,x_tsp,idxs,stopsLon,stopsLat);
title('2-OPT Approximate Path');


%%%%

tours = matlabSubtours(x_tsp,idxs);
numtours = length(tours); % number of subtours
fprintf('# of subtours: %d\n',numtours);


%%%%

A = spalloc(0,lendist,0); % Allocate a sparse linear inequality constraint matrix
b = [];
while numtours > 1 % repeat until there is just one subtour
    % Add the subtour constraints
    b = [b;zeros(numtours,1)]; % allocate b
    A = [A;spalloc(numtours,lendist,nStops)]; % a guess at how many nonzeros to allocate
    for ii = 1:numtours
        rowIdx = size(A,1)+1; % Counter for indexing
        subTourIdx = tours{ii}; % Extract the current subtour
        %         The next lines find all of the variables associated with the
        %         particular subtour, then add an inequality constraint to prohibit
        %         that subtour and all subtours that use those stops.
        variations = nchoosek(1:length(subTourIdx),2);
        for jj = 1:length(variations)
            whichVar = (sum(idxs==subTourIdx(variations(jj,1)),2)) & ...
                (sum(idxs==subTourIdx(variations(jj,2)),2));
            A(rowIdx,whichVar) = 1;
        end
        b(rowIdx) = length(subTourIdx)-1; % One less trip than subtour stops
    end
    
    % Try to optimize again
    [x_tsp,costopt,exitflag,output] = intlinprog(dist,intcon,A,b,Aeq,beq,lb,ub,opts);
    
    % Visualize result
    lh = matlabUpdatePlot(lh,x_tsp,idxs,stopsLon,stopsLat);
    pause(0.5)
    
    % How many subtours this time?
    tours = matlabSubtours(x_tsp,idxs);
    numtours = length(tours); % number of subtours
    fprintf('# of subtours: %d\n',numtours);
end

%%%%
tours_index = tours{1};
conc_stops = [stopsLon stopsLat];
sorted_tours = conc_stops;
for i = 1:length(tours_index)
    index = tours_index(i);
    sorted_tours(i, 1:2) = conc_stops(index, 1:2);
end



%title('2-OPT Approximate Path');
hold on

disp(output.absolutegap)
end