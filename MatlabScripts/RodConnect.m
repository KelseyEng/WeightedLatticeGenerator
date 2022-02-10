
% Description: Generates Rod Mats rod connections
% Parent Function: pConnectUCGen
% Child Function: None
% Brown Research Group 
% Author: Kelsey Snapp
% Date  : April 21, 2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Revision: 
% Date             Author         Brief Description 
% 5/13/2020         Kelsey          Added multi-switch functionality
%5/17/2020          Kelsey          Updated Mat Creation Section to allow
%for non-cubic unit cells (previous bug). Use flip rather than rotation.
%5/17/2020          Kelsey          Added UCSwitch 7, which compresses then
%stretches unit cell.
%5/19/2020          Kelsey          Added I-beam (UCSwitch8)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function RodMats = RodConnect(resolutionOfUnitCell,ConnectionMatrix,UCPoints,UCSwitch,strutStretch)
    
    RodMats = RodGen(ConnectionMatrix,UCPoints,resolutionOfUnitCell, strutStretch);
    

    
    
    %%Mat Creation Section 
     
    switch UCSwitch

            case 5 %Octet and Octet with vertical stretch
                 RodMat1 = RodMats(:,:,:,1);
                 RodMat2 = RodMats(:,:,:,2);
                 RodMat3 = RodMats(:,:,:,3);
                 RodMat4 = RodMats(:,:,:,4);
                 RodMat5 = RodMats(:,:,:,5);
                 RodMat6 = RodMats(:,:,:,6);
                 
                 %Combine RodMat 2 and 3 because they are both vertical edge struts
                 RodMat2 = RodMat2 + RodMat3;
                 
                          
                 %Combine Rodmat 4 & 5 because they are both interior edge struts
                 RodMat4 = RodMat4 + RodMat5;


                 %Scale Rod Mats
                 RodMat1 = RodMat1-min(RodMat1(:));
                 RodMat1 = RodMat1./max(RodMat1(:));

                 RodMat2 = RodMat2-min(RodMat2(:));
                 RodMat2 = RodMat2./max(RodMat2(:));

                 RodMat4 = RodMat4-min(RodMat4(:));
                 RodMat4 = RodMat4./max(RodMat4(:));

                 RodMat6 = RodMat6-min(RodMat6(:));
                 RodMat6 = RodMat6./max(RodMat6(:));
                 
                 clear RodMats

                 RodMats(:,:,:,4)=RodMat6;
                 RodMats(:,:,:,1)=RodMat1;
                 RodMats(:,:,:,2)=RodMat2;
                 RodMats(:,:,:,3)=RodMat4;
                 
        case 6 %Octed with vertical rod
                 RodMat1 = RodMats(:,:,:,1);
                 RodMat2 = RodMats(:,:,:,2);
                 RodMat3 = RodMats(:,:,:,3);
                 RodMat4 = RodMats(:,:,:,4);
                 RodMat5 = RodMats(:,:,:,5);
                 RodMat6 = RodMats(:,:,:,6);
                 RodMat7 = RodMats(:,:,:,7);
                 
                 %Combine RodMat 2 and 3 because they are both vertical edge struts
                 RodMat2 = RodMat2 + RodMat3;
                 
                          
                 %Combine Rodmat 4 & 5 because they are both interior edge struts
                 RodMat4 = RodMat4 + RodMat5;
              
                 %Scale Rod Mats
                 RodMat1 = RodMat1-min(RodMat1(:));
                 RodMat1 = RodMat1./max(RodMat1(:));

                 RodMat2 = RodMat2-min(RodMat2(:));
                 RodMat2 = RodMat2./max(RodMat2(:));

                 RodMat4 = RodMat4-min(RodMat4(:));
                 RodMat4 = RodMat4./max(RodMat4(:));

                 RodMat6 = RodMat6-min(RodMat6(:));
                 RodMat6 = RodMat6./max(RodMat6(:));
                 
                 RodMat7 = RodMat7-min(RodMat7(:));
                 RodMat7 = RodMat7./max(RodMat7(:));
                 
                 clear RodMats

                 RodMats(:,:,:,5)=RodMat7;
                 RodMats(:,:,:,1)=RodMat1;
                 RodMats(:,:,:,2)=RodMat2;
                 RodMats(:,:,:,3)=RodMat4;
                 RodMats(:,:,:,4)=RodMat6;
                 
            case 7 %Octa
                 RodMat1 = RodMats(:,:,:,1);
                 RodMat2 = RodMats(:,:,:,2);
                 RodMat3 = RodMats(:,:,:,3);

                 
                 %Combine RodMat 2 and 3 because they are both vertical edge struts
                 RodMat1 = RodMat1 + RodMat2;

                 %Scale Rod Mats
                 RodMat1 = RodMat1-min(RodMat1(:));
                 RodMat1 = RodMat1./max(RodMat1(:));

                 RodMat3 = RodMat3-min(RodMat3(:));
                 RodMat3 = RodMat3./max(RodMat3(:));

                 clear RodMats

                 RodMats(:,:,:,2)=RodMat3;
                 RodMats(:,:,:,1)=RodMat1;
                 
                 
             case 8 %Reinforced Octa
                 RodMat1 = RodMats(:,:,:,1);
                 RodMat2 = RodMats(:,:,:,2);
                 RodMat3 = RodMats(:,:,:,3);
                 RodMat4 = RodMats(:,:,:,4);

                 
                 %Combine RodMat 2 and 3 because they are both vertical edge struts
                 RodMat1 = RodMat1 + RodMat2;
                 
                          



                 %Scale Rod Mats
                 RodMat1 = RodMat1-min(RodMat1(:));
                 RodMat1 = RodMat1./max(RodMat1(:));

                 RodMat3 = RodMat3-min(RodMat3(:));
                 RodMat3 = RodMat3./max(RodMat3(:));
                 
                 RodMat4 = RodMat4-min(RodMat4(:));
                 RodMat4 = RodMat4./max(RodMat4(:));

                 clear RodMats
                 RodMats(:,:,:,3)=RodMat4;
                 RodMats(:,:,:,2)=RodMat3;
                 RodMats(:,:,:,1)=RodMat1;
                 
                 
                 case 9 %Circular Octa
                 RodMats = sum(RodMats,4);

                 %Scale Rod Mats
                 RodMats = RodMats-min(RodMats(:));
                 RodMats = RodMats./max(RodMats(:));

                 
                 case 10 %BCC
                 %Scale Rod Mats
                 RodMats = RodMats-min(RodMats(:));
                 RodMats = RodMats./max(RodMats(:));


    end
end