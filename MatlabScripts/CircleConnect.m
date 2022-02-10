% Description: Uses Circular Paths to create curved strut mats
% Parent Function: None
% Child Function: generateAM
% Brown Research Group 
% Author: Kelsey Snapp
% Date  : September 3, 2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Revision: 
% Date             Author         Brief Description 
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



function CircleMats = CircleConnect(resolutionOfUnitCell,circleCenters,circleVectors,UCType,strutStretch)
    
    CircleMats = CircGen(circleCenters,circleVectors,resolutionOfUnitCell, strutStretch);

    switch UCType

        case 9 %Circular Octa

            CircleMats = sum(CircleMats,4);

            %Scale Rod Mats
            CircleMats = CircleMats-min(CircleMats(:));
            CircleMats = CircleMats./max(CircleMats(:));

    end

end