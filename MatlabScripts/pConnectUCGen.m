% Description: Generates Unit Cell Using Points and Connection Matrix
% Parent Function: None
% Child Function: generateAM
% Brown Research Group 
% Author: Kelsey Snapp
% Date  : Before April 22, 2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Revision: 
% Date             Author         Brief Description 
% 5/13/2020         Kelsey          Edited to save Mats and load from file
% 5/19/2020          Kelsey          Added I-beam (UCSwitch8)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [RodMats, JointMats,UCPoints] = pConnectUCGen(resolutionOfUnitCell,UCType, strutStretch)

    fprintf('Calculating Mats\n')


            %% Define Points and Connection Matrix
            switch UCType

                case 5 %Octet
                    % Point Matrix (on scale of 0 to 1 for Convenience)
                    UCPoints = [0 0 0     %1
                        .5 .5 0    %2
                         0 .5 .5   %3
                        .5 0 .5];  %4

                    %Scales P matrix by resolution
                    UCPoints = UCPoints .*(resolutionOfUnitCell-1)+1;

                    % Connection Matrix (by P Row)
                    C = [1 2   %1
                        1 3    %2
                        1 4    %3
                        2 3    %4
                        2 4    %5
                        3 4];  %6

                case 6 %Octet with vertical rod
                    % Point Matrix (on scale of 0 to 1 for Convenience)
                    UCPoints = [0 0 0     %1
                        .5 .5 0    %2
                         0 .5 .5   %3
                        .5 0 .5    %4
                        0 0 .5];   %5

                    %Scales P matrix by resolution
                    UCPoints = UCPoints .*(resolutionOfUnitCell-1)+1;

                    % Connection Matrix (by P Row)
                    C = [1 2   %1
                        1 3    %2
                        1 4    %3
                        2 3    %4
                        2 4    %5
                        3 4    %6
                        1 5];  %7

                case 7 %Octa
                    % Point Matrix (on scale of 0 to 1 for Convenience)
                    UCPoints = [.5 .5 0    %1
                         0 .5 .5   %2
                        .5 0 .5];  %3

                    %Scales P matrix by resolution
                    UCPoints = UCPoints .*(resolutionOfUnitCell-1)+1;

                    % Connection Matrix (by P Row)
                    C = [1 2    %1
                         1 3    %2
                         2 3];  %3
                    
                case 8 %Reinforced Octa
                    % Point Matrix (on scale of 0 to 1 for Convenience)
                    UCPoints = [.5 .5 0    %1
                         0 .5 .5   %2
                        .5 0 .5     %3
                        .5 .5 .5];  %4

                    %Scales P matrix by resolution
                    UCPoints = UCPoints .*(resolutionOfUnitCell-1)+1;

                    % Connection Matrix (by P Row)
                    C = [1 2    %1
                         1 3    %2
                         2 3    %3
                         1 4];  %4
                     
                     
                case {9} %Circular Octa
                    UCPoints = [.5 .5 0    %1
                         0 .5 .5   %2
                        .5 0 .5     %3
                        .5 .5 .5];  %4
                    
                    %Scales P matrix by resolution                  
                    UCPoints = UCPoints .*(resolutionOfUnitCell-1)+1;

                    % Connection Matrix (by P Row)
                    C = [2, 4   %1
                         3, 4   %2
                         ];
                     
                    circleCenters = [.5 .5 .5   %1
                                    .5 .5 .5    %2
                                    ];      %Defines center of circles for curved struts.
                    circleVectors = [0 .5 .5
                                    .5 0 .5
                                    ];      %Defines 2nd point in vector from center of circle (perpindicular to plane that contains circle). Length defines desired radius of circle.
                        
                    %Scales circle matrices by resolution
                    circleCenters = circleCenters.*[resolutionOfUnitCell(1)-1,resolutionOfUnitCell(2)-1,resolutionOfUnitCell(3)-1]+1;
                    circleVectors = circleVectors.*[resolutionOfUnitCell(1)-1,resolutionOfUnitCell(2)-1,resolutionOfUnitCell(3)-1]+1;
                    
                    
                    
                case 10 %BCC
                    UCPoints = [0 0 0 %1
                         .5 .5 .5 %2
                         ];
                     
                    %Scales P matrix by resolution                  
                    UCPoints = UCPoints .*(resolutionOfUnitCell-1)+1;

                    % Connection Matrix (by P Row)
                    C = [1, 2   %1
                         ];                     
            end

            %% Resize resolutionOfUnitCell
            resolutionOfUnitCell = ceil(resolutionOfUnitCell./2);

            
            %%Create Mesh Grid    
            AX = [1:resolutionOfUnitCell(1)];
            AY = [1:resolutionOfUnitCell(2)];
            AZ = [1:resolutionOfUnitCell(3)];
            [MY,MX,MZ] = meshgrid(AY,AX,AZ);


            RodMats = RodConnect(resolutionOfUnitCell,C,UCPoints,UCType,strutStretch);
            
            if exist('circleCenters','var')
                CircleMats = CircleConnect(resolutionOfUnitCell,circleCenters,circleVectors,UCType,strutStretch);
                RodMats = cat(4,CircleMats,RodMats);              
            end



             %% Point Matrices

            JointMats = CreateJointMats(UCPoints,MY,MX,MZ, UCType);

          
        fprintf('Done calculating Mats\n')
end

                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 