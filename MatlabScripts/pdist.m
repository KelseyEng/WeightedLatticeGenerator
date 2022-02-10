% Description: Calculates distance from point to line
% Parent Function: pConnectUCGen
% Child Function: None
% Brown Research Group 
% Author: Kelsey Snapp
% Date  : April 21, 2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Revision: 
% Date             Author         Brief Description 
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function out = pdist(line,lengthLine,lp1,p1)
    b = p1 -lp1; 
    out = norm(cross(line,b))/lengthLine; 
end