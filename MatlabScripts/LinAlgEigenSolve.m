% Description: Uses Linear Algebra to find Eigenvalues
% Parent Function: Main_UnitCellTesterAM
% Child Function: none
% Brown Research Group 
% Author: Kelsey Snapp
% Date  : May 11, 2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Revision: 
% Date             Author         Brief Description 
% 5/13/2020         Kelsey          Added multi-switch functionality
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [AM,finalFillFraction,x] = LinAlgEigenSolve(resolutionOfUnitCell,Distances,RodMats, JointMats,UCType,P)


    %% Find points at requested distances
     LinPoints = GetLinPoints(resolutionOfUnitCell,UCType,Distances);
    
    [AM,x] = SolveA(LinPoints,RodMats,JointMats,UCType);
    
    AM = CheckHollowJoints(AM,P,Distances,UCType);
    finalFillFraction = sum(AM(:)>=.5)/numel(AM); % Report Final Fill Fraction 
    
end