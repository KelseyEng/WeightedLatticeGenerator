% Description: Creates AM from Mats
% Parent Function: LinAlgEigenSolve
% Child Function: none
% Brown Research Group 
% Author: Kelsey Snapp
% Date  : May 12, 2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Revision: 
% Date             Author         Brief Description 
% 5/13/2020         Kelsey          Added multi-switch functionality
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [AM,x] = SolveA(LinPoints,RodMats,JointMats,UCType)

%% Set up Matrix with values at desired Points
    switch UCType

    case 5 %Octet  
        A = zeros(7,7);
        for j = 1:7
            A(j,1) = RodMats(LinPoints(j,1),LinPoints(j,2),LinPoints(j,3),1);
            A(j,2) = RodMats(LinPoints(j,1),LinPoints(j,2),LinPoints(j,3),2);
            A(j,3) = RodMats(LinPoints(j,1),LinPoints(j,2),LinPoints(j,3),3);
            A(j,4) = RodMats(LinPoints(j,1),LinPoints(j,2),LinPoints(j,3),4);
            A(j,5) = JointMats(LinPoints(j,1),LinPoints(j,2),LinPoints(j,3),1);
            A(j,6) = JointMats(LinPoints(j,1),LinPoints(j,2),LinPoints(j,3),2);
            A(j,7) = JointMats(LinPoints(j,1),LinPoints(j,2),LinPoints(j,3),3);

        end
        
    case 6 %Octet with vertical rod 
        A = zeros(8,8); 
        for j = 1:8
            A(j,1) = RodMats(LinPoints(j,1),LinPoints(j,2),LinPoints(j,3),1);
            A(j,2) = RodMats(LinPoints(j,1),LinPoints(j,2),LinPoints(j,3),2);
            A(j,3) = RodMats(LinPoints(j,1),LinPoints(j,2),LinPoints(j,3),3);
            A(j,4) = RodMats(LinPoints(j,1),LinPoints(j,2),LinPoints(j,3),4);
            A(j,5) = JointMats(LinPoints(j,1),LinPoints(j,2),LinPoints(j,3),1);
            A(j,6) = JointMats(LinPoints(j,1),LinPoints(j,2),LinPoints(j,3),2);
            A(j,7) = JointMats(LinPoints(j,1),LinPoints(j,2),LinPoints(j,3),3);
            A(j,8) = RodMats(LinPoints(j,1),LinPoints(j,2),LinPoints(j,3),5);

        end
    case 7 %Octa  
        A = zeros(4,4);
        for j = 1:4
            A(j,1) = RodMats(LinPoints(j,1),LinPoints(j,2),LinPoints(j,3),1);
            A(j,2) = RodMats(LinPoints(j,1),LinPoints(j,2),LinPoints(j,3),2);
            A(j,3) = JointMats(LinPoints(j,1),LinPoints(j,2),LinPoints(j,3),1);
            A(j,4) = JointMats(LinPoints(j,1),LinPoints(j,2),LinPoints(j,3),2);
        end
 
    case 8 %Reinforced Octa  
        A = zeros(5,5);
        for j = 1:5
            A(j,1) = RodMats(LinPoints(j,1),LinPoints(j,2),LinPoints(j,3),1);
            A(j,2) = RodMats(LinPoints(j,1),LinPoints(j,2),LinPoints(j,3),2);
            A(j,3) = JointMats(LinPoints(j,1),LinPoints(j,2),LinPoints(j,3),1);
            A(j,4) = JointMats(LinPoints(j,1),LinPoints(j,2),LinPoints(j,3),2);
            A(j,5) = RodMats(LinPoints(j,1),LinPoints(j,2),LinPoints(j,3),3);
        end        
    
        
    case 9 %Circular Octa  
        A = zeros(4,4);
        for j = 1:4
            A(j,1) = RodMats(LinPoints(j,1),LinPoints(j,2),LinPoints(j,3),1);
            A(j,2) = RodMats(LinPoints(j,1),LinPoints(j,2),LinPoints(j,3),2);
            A(j,3) = JointMats(LinPoints(j,1),LinPoints(j,2),LinPoints(j,3),1);
            A(j,4) = JointMats(LinPoints(j,1),LinPoints(j,2),LinPoints(j,3),2);
        end
        
        
    case 10 %BCC 
        A = zeros(2,2);
        for j = 1:2
            A(j,1) = RodMats(LinPoints(j,1),LinPoints(j,2),LinPoints(j,3));
            A(j,2) = JointMats(LinPoints(j,1),LinPoints(j,2),LinPoints(j,3));
        end   
        
        
    end
    
    %%Solve system
    b = ones(size(A,1),1)*.5;
    x = A\b;

    AM = combineMats(RodMats,JointMats,x,UCType);
end


