% Description: Gives a check point by Unit Cell Type when validating Z Adjust to Fill Fraction
% Parent Function: KiteSearch
% Child Function: 
% Brown Research Group 
% Author: Kelsey Snapp
% Date  : November 8, 2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Revision: 
% Date             Author         Brief Description 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function checkPoint = getCheckPoint(UCType,resolutionOfFinalLattice)


switch UCType
    case {5,6}
        checkPoint = ceil(resolutionOfFinalLattice./[4,4,resolutionOfFinalLattice(3)]);        
    case {7,8}
        
        
    case 9
        
    case 10




end