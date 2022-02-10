% Description: Creates AM from Mats
% Parent Function: SolveA
% Child Function: none
% Brown Research Group 
% Author: Kelsey Snapp
% Date  : May 17, 2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Revision: 
% Date             Author         Brief Description 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function AM = combineMats(RodMats,JointMats,x,UCType)

    switch UCType
        case 5 %Octet 
            AM = RodMats(:,:,:,1)*x(1) + RodMats(:,:,:,2)*x(2) + RodMats(:,:,:,3)*x(3) + RodMats(:,:,:,4)*x(4) + JointMats(:,:,:,1)*x(5) + JointMats(:,:,:,2)*x(6) + JointMats(:,:,:,3)*x(7);
        case 6 %Octet with vertical rod
             AM = RodMats(:,:,:,1)*x(1) + RodMats(:,:,:,2)*x(2) + RodMats(:,:,:,3)*x(3) + RodMats(:,:,:,4)*x(4) + JointMats(:,:,:,1)*x(5) + JointMats(:,:,:,2)*x(6) + JointMats(:,:,:,3)*x(7) + RodMats(:,:,:,5)*x(8);
        case 7 %Octa 
            AM = RodMats(:,:,:,1)*x(1) + RodMats(:,:,:,2)*x(2) + JointMats(:,:,:,1)*x(3) + JointMats(:,:,:,2)*x(4);
        case 8 %Reinforced Octa 
            AM = RodMats(:,:,:,1)*x(1) + RodMats(:,:,:,2)*x(2) + JointMats(:,:,:,1)*x(3) + JointMats(:,:,:,2)*x(4) + RodMats(:,:,:,3)*x(5);          
        case 9 %Circular Octa
            AM = RodMats(:,:,:,1)*x(1) + RodMats(:,:,:,2)*x(2) + JointMats(:,:,:,1)*x(3) + JointMats(:,:,:,2)*x(4);
        case 10 %BCC
            AM = RodMats(:,:,:)*x(1) + JointMats(:,:,:)*x(2);
   
    end
    
end