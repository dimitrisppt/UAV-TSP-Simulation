function dmat = calculateDistance(a,varargin)
    
    
    % Set defaults

    b = a;

    
    % Check input dimensionality
    [na,aDims] = size(a);
    [nb,bDims] = size(b);
    if (aDims ~= bDims)
        error('Input matrices must have the same dimensionality.');
    end
    
    % Create index matrices
    [j,i] = meshgrid(1:nb,1:na);
    
    % Compute array of inter-point differences
    delta = a(i,:) - b(j,:);
    
    % Compute distance by specified method
    dmat = zeros(na,nb);
    
    % Manhattan distance
    dmat(:) = sum(abs(delta),2)
           
    
end

