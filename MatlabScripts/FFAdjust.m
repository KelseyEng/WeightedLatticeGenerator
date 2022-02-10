% Description: Adjusts Lattice so that it hits FFTarget as closely as possible.
% Parent Function: None
% Child Function: generateAM
% Brown Research Group 
% Author: Kelsey Snapp
% Date  : September 30, 2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Revision: 

function AM = FFAdjust(AM,FFTarget)
    AM1D = sort(AM(:),'descend'); %Sort matrix into 1D Array with descending sort.
    AMLength = length(AM1D);   %Find length of 1D array.
    PivotValue = round(AMLength*FFTarget); %Find the value that should be exactly .5 so that the FFTarget is met.
    MatAdjust = .5 - AM1D(PivotValue); % Find the amount the PivotValue must be adjusted so that it is .5.
    AM = AM + MatAdjust;    %Adjust the entire matrix so that the Pivot Value is .5.
end