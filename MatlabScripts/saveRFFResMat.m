% Description: Saves RFFResMat Data in proper format
% Parent Function: Main
% Child Function: None
% Brown Research Group 
% Author: Kelsey Snapp
% Date  : July 3, 2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Revision: 
% Date             Author         Brief Description 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function out = saveRFFResMat(UCSwitch,resolutionOfUnitCell, strutRadius,jointRadius, fillFractionResultsMatrix)

    strutRadius = round(strutRadius);
    jointRadius = round(jointRadius);
    out = [UCSwitch, resolutionOfUnitCell, strutRadius,jointRadius, fillFractionResultsMatrix];



end