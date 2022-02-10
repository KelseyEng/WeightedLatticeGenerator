% Description: Generates Cylindrical Rods through the C mat
% Parent Function: pConnectUCGen
% Child Function: None
% Brown Research Group 
% Author: Kelsey Snapp
% Date  : May 19, 2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Revision: 
% Date             Author         Brief Description 
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function RodMats = RodGen(ConnectionMatrix,UCPoints,resolutionOfUnitCell, strutStretch)
    RodMats = zeros([resolutionOfUnitCell,size(ConnectionMatrix,1)]);
     for i=1:size(ConnectionMatrix,1)
        linep1 =[UCPoints(ConnectionMatrix(i,1),1),UCPoints(ConnectionMatrix(i,1),2),UCPoints(ConnectionMatrix(i,1),3)].*strutStretch;
        linep2 = [UCPoints(ConnectionMatrix(i,2),1),UCPoints(ConnectionMatrix(i,2),2),UCPoints(ConnectionMatrix(i,2),3)].*strutStretch;
        linev = linep1-linep2;
        lengthLine = norm(linev); 
         for x=1:resolutionOfUnitCell(1)
             for y = 1:resolutionOfUnitCell(2)
                 for z = 1:resolutionOfUnitCell(3)

                    RodMats(x,y,z,i) = 1/(pdist(linev,lengthLine,linep1,[x,y,z].*strutStretch)+1); % Calculates adjustment to matrix based on distance from line

                 end
             end
         end
     end
     
     
     
end