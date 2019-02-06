function lh = matlabUpdatePlotapp(lh,xopt,idxs,stopsLat,stopsLon, app)
% Plotting function for tsp_intlinprog example

%   Copyright 2014-2018 The MathWorks, Inc. 

if ( lh ~= zeros(size(lh)) ) % First time through lh is all zeros
    delete(lh) % Get rid of unneeded lines
end

segments = find(round(xopt)); % Indices to trips in solution

% Loop through the trips then draw them
Lat = zeros(3*length(segments),1);
Lon = zeros(3*length(segments),1);
for ii = 1:length(segments)
    start = idxs(segments(ii),1);
    stop = idxs(segments(ii),2);
    
    % Separate data points with NaN's to plot separate line segments
    Lat(3*ii-2:3*ii) = [stopsLat(start); stopsLat(stop); NaN];
    Lon(3*ii-2:3*ii) = [stopsLon(start); stopsLon(stop); NaN];  
end

lh = plot(app.UIAxes, Lat,Lon,'k:','LineWidth',2);
drawnow; % Add new lines to plot