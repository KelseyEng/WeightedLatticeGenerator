% Description: Gets LinPoints
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

function LinPoints = GetLinPoints(resolutionOfUnitCell,UCSwitch,Distances)

         switch UCSwitch

            case 5 %Octet   
                LinPoints = zeros(7,3);
                LinPoints(1,:) = [ceil(resolutionOfUnitCell(1)/4),1+Distances(1),ceil(resolutionOfUnitCell(3)/4)];
                LinPoints(2,:) = [ceil(resolutionOfUnitCell(1)/4),ceil(resolutionOfUnitCell(2)/2)-Distances(2),ceil(resolutionOfUnitCell(3)/4)];
                LinPoints(3,:) = [ceil(resolutionOfUnitCell(1)/4),ceil(resolutionOfUnitCell(2)/4),ceil(resolutionOfUnitCell(3)/2)-Distances(3)];
                LinPoints(4,:) = [ceil(resolutionOfUnitCell(1)/4),ceil(resolutionOfUnitCell(2)/4),1+Distances(4)];
                LinPoints(5,:) = [1+Distances(5),1,1];
                LinPoints(6,:) = [ceil(resolutionOfUnitCell(1)/2),1,ceil(resolutionOfUnitCell(3)/2)-Distances(6)];
                LinPoints(7,:) = [ceil(resolutionOfUnitCell(1)/2)-Distances(7),ceil(resolutionOfUnitCell(2)/2),1];

                
            case 6 %Octet with vertical rod   
                LinPoints = zeros(8,3);
                LinPoints(1,:) = [ceil(resolutionOfUnitCell(1)/4),1+Distances(1),ceil(resolutionOfUnitCell(3)/4)];  %edge diagonal beam
                LinPoints(2,:) = [ceil(resolutionOfUnitCell(1)/4),ceil(resolutionOfUnitCell(2)/2)-Distances(2),ceil(resolutionOfUnitCell(3)/4)]; %interior diagonal beam
                LinPoints(3,:) = [ceil(resolutionOfUnitCell(1)/4),ceil(resolutionOfUnitCell(2)/4),ceil(resolutionOfUnitCell(3)/2)-Distances(3)]; %interior flat beam
                LinPoints(4,:) = [ceil(resolutionOfUnitCell(1)/4),ceil(resolutionOfUnitCell(2)/4),1+Distances(4)]; %bottom flat beam,
                LinPoints(5,:) = [1+Distances(5),1,1]; %Corner Joint
                LinPoints(6,:) = [ceil(resolutionOfUnitCell(1)/2),1,ceil(resolutionOfUnitCell(3)/2)-Distances(6)]; %Side Joint
                LinPoints(7,:) = [ceil(resolutionOfUnitCell(1)/2)-Distances(7),ceil(resolutionOfUnitCell(2)/2),1]; %Bottom Joint
                LinPoints(8,:) = [1+Distances(8),1,ceil(resolutionOfUnitCell(3)/2)]; %

            case 7 %Octa   
                LinPoints = zeros(4,3);
                LinPoints(1,:) = [ceil(resolutionOfUnitCell(1)/4),ceil(resolutionOfUnitCell(2)/2)-Distances(1),ceil(resolutionOfUnitCell(3)/4)];
                LinPoints(2,:) = [ceil(resolutionOfUnitCell(1)/4),ceil(resolutionOfUnitCell(2)/4),ceil(resolutionOfUnitCell(3)/2)-Distances(2)];
                LinPoints(3,:) = [ceil(resolutionOfUnitCell(1)/2),1,ceil(resolutionOfUnitCell(3)/2)-Distances(3)];
                LinPoints(4,:) = [ceil(resolutionOfUnitCell(1)/2)-Distances(4),ceil(resolutionOfUnitCell(2)/2),1];

            case 8 %Reinforced Octa   
                LinPoints = zeros(5,3);
                LinPoints(1,:) = [ceil(resolutionOfUnitCell(1)/4),ceil(resolutionOfUnitCell(2)/2)-Distances(1),ceil(resolutionOfUnitCell(3)/4)];
                LinPoints(2,:) = [ceil(resolutionOfUnitCell(1)/4),ceil(resolutionOfUnitCell(2)/4),ceil(resolutionOfUnitCell(3)/2)-Distances(2)];
                LinPoints(3,:) = [ceil(resolutionOfUnitCell(1)/2),1,ceil(resolutionOfUnitCell(3)/2)-Distances(3)];
                LinPoints(4,:) = [ceil(resolutionOfUnitCell(1)/2)-Distances(4),ceil(resolutionOfUnitCell(2)/2),1];                
                LinPoints(5,:) = [ceil(resolutionOfUnitCell(1)/2)-Distances(5),ceil(resolutionOfUnitCell(2)/2),ceil(resolutionOfUnitCell(3)/4)]; 
                
            case 9 %Circular Octa   
                LinPoints = zeros(4,3);
                LinPoints(1,:) = [ceil(resolutionOfUnitCell(1)/2)-sqrt((resolutionOfUnitCell(1)/2)*(resolutionOfUnitCell(3)/2)/2),ceil(resolutionOfUnitCell(2)/2)-Distances(1),ceil(resolutionOfUnitCell(3)/2)-sqrt((resolutionOfUnitCell(1)/2)*(resolutionOfUnitCell(3)/2)/2)];  %Circular Reference
                LinPoints(2,:) = [ceil(resolutionOfUnitCell(1)/2)-Distances(2),ceil(resolutionOfUnitCell(2)/4),ceil(resolutionOfUnitCell(3)/2)];        %Horizontal Reference
                LinPoints(3,:) = [ceil(resolutionOfUnitCell(1)/2)-Distances(3),1,ceil(resolutionOfUnitCell(3)/2)];                  % Side Joint
                LinPoints(4,:) = [ceil(resolutionOfUnitCell(1)/2)-sqrt((Distances(4)^2)/2),ceil(resolutionOfUnitCell(2)/2)-sqrt((Distances(4)^2)/2),1];                  %Bottom Joint
                
            case 10 %BCC 
                LinPoints = zeros(2,3);
                LinPoints(1,:) = [ceil(resolutionOfUnitCell(1)/4)-sqrt(Distances(1)^2/3),ceil(resolutionOfUnitCell(2)/4)-sqrt(Distances(1)^2/3),ceil(resolutionOfUnitCell(3)/4)+sqrt(Distances(1)^2/3)];
                LinPoints(2,:) = [1,1,1+Distances(2)];

         end

        LinPoints(LinPoints<=1)=1;
        LinPoints(LinPoints(:,1)>resolutionOfUnitCell(1)/2,1)=resolutionOfUnitCell(1)/2;
        LinPoints(LinPoints(:,2)>resolutionOfUnitCell(2)/2,2)=resolutionOfUnitCell(2)/2;
        LinPoints(LinPoints(:,3)>resolutionOfUnitCell(3)/2,3)=resolutionOfUnitCell(3)/2;
        LinPoints = round(LinPoints);
    
    
end