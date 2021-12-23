function [direction] = edgeDirection(EWh,EWv)
% This function determines the edge direction. 
% Inputs EWh and EWv are assumed to be square matrices of the same size
%   Horizontal if threshold is exceeded in a single row
%   Vertical if thresgold is exceeded in a single column
%   Diagonal else

threshold = length(EWh)/2 + 1;
direction = 3; % assume direction is 3 (diagonal) for now

for i=1:length(EWh)
    rowCount = 0;
    colCount = 0;
    for j=1:length(EWh)
        rowCount = rowCount + EWh(i,j);
        colCount = colCount + EWv(j,i);
        if rowCount >= threshold
            direction = 1; % Horizontal
            return;
        elseif colCount >= threshold
            direction = 2; % Vertical
            return;
        end
    end
end


end

