
% Description: Creates Joint Matrices and Adjusts UC
% Parent Function: None
% Child Function: generateAM
% Brown Research Group 
% Author: Kelsey Snapp
% Date  : April 22, 2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Revision: 
% Date             Author         Brief Description 
% 5/17/2020         Kelsey          Fixed bug that only allowed for cubic
% unitcells (flip instead of rot90)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function JointMats = CreateJointMatsEighths(P,MY,MX,MZ,UCType)
    




    
    %Calculate Adjustment for each Adjustment Point
     for i = 1:size(P)
        temp = 1/((P(i,1)-MX).^2+(P(i,2)-MY).^2+(P(i,3)-MZ).^2+1).^.5;
        switch i
            case 1
                JointMat1 = temp;
            case 2
                JointMat2 = temp;
            case 3
                JointMat3 = temp;
            case 4
                JointMat4 = temp;
        end
     end

   switch UCType
       case {5,6}
            JointMat3 = JointMat3 + JointMat4;
    

            % Scale Joint Mats to 0-1

             JointMat1 = JointMat1-min(JointMat1(:));
             JointMat1 = JointMat1./max(JointMat1(:));

             JointMat2 = JointMat2-min(JointMat2(:));
             JointMat2 = JointMat2./max(JointMat2(:));

             JointMat3 = JointMat3-min(JointMat3(:));
             JointMat3 = JointMat3./max(JointMat3(:));

             JointMats(:,:,:,3) = JointMat3;
             JointMats(:,:,:,2) = JointMat2;
             JointMats(:,:,:,1) = JointMat1;
             
       case {7,8,9}
             JointMat2 = JointMat2 + JointMat3;
             
             JointMat1 = JointMat1-min(JointMat1(:));
             JointMat1 = JointMat1./max(JointMat1(:));

             JointMat2 = JointMat2-min(JointMat2(:));
             JointMat2 = JointMat2./max(JointMat2(:));
             
             JointMats(:,:,:,2) = JointMat2;
             JointMats(:,:,:,1) = JointMat1;
             
       case 10
           JointMats = JointMat1 + JointMat2;
           
           JointMats = JointMats-min(JointMats(:));
           JointMats = JointMats./max(JointMats(:));
           
   end
end