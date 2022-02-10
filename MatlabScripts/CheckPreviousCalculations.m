% Description: Check to see if we already know Fill Fraction for that R value set
% Parent Function: Main_UnitCellTesterAM
% Child Function: none
% Brown Research Group 
% Author: Kelsey Snapp
% Date  : Before April 22, 2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Revision: 
% Date             Author         Brief Description 
% 5/13/2020         Kelsey          Edited to save Mats and load from file
% 5/19/2020          Kelsey          Added I-beam (UCSwitch8)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




function out = CheckPreviousCalculations(UCType, resolutionOfUnitCell, strutRadius, jointRadius, fillFractionResultsMatrix)
    strutRadius = round(strutRadius);
    index = (fillFractionResultsMatrix(:,1) == UCType & fillFractionResultsMatrix(:,2) == resolutionOfUnitCell(1) & fillFractionResultsMatrix(:,3) == resolutionOfUnitCell(2) & fillFractionResultsMatrix(:,4) == resolutionOfUnitCell(3) & fillFractionResultsMatrix(:,5) == strutRadius(1) & fillFractionResultsMatrix(:,6) == strutRadius(2) & fillFractionResultsMatrix(:,7) == strutRadius(3) & fillFractionResultsMatrix(:,8) == jointRadius)==1;
    
    if sum(index)==0
        out = 0;
    else
        out = fillFractionResultsMatrix(index,9);
    end
end