% Description: Interpolates Matrix to Lower Level
% Parent Function: Main_UnitCellTesterAM
% Child Function: None
% Brown Research Group 
% Author: Kelsey Snapp
% Date  : 6/7/2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Revision: 
% Date             Author         Brief Description 
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function AM = InterpMatDown(AM,resolutionOfUnitCell, resolutionOfFinalLattice)

      %Interp Code    
    xa = [1:resolutionOfUnitCell(1)];
    ya = [1:resolutionOfUnitCell(2)];
    za = [1:resolutionOfUnitCell(3)];
    xa2 = linspace(1,resolutionOfUnitCell(1),resolutionOfFinalLattice(1));
    ya2 = linspace(1,resolutionOfUnitCell(2),resolutionOfFinalLattice(2));
    za2 = linspace(1,resolutionOfUnitCell(3),resolutionOfFinalLattice(3));
    AM = interp3(ya,xa',za,AM,ya2,xa2',za2);
    
end