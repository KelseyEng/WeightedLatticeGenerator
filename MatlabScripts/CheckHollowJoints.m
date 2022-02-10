% Description: Checks for hollow joints and fixes them
% Parent Function: Main_UnitCelTesterAM
% Child Function: None
% Brown Research Group 
% Author: Kelsey Snapp
% Date  : May 13, 2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Revision: 
% Date             Author         Brief Description 
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function AM = CheckHollowJoints(AM,P,Distances,UCType)

    [r,c,h] = size(AM);
        % Create Meshgrid to use in calcuations
        AX = [1:r];
        AY = [1:c];
        AZ = [1:h];
        [MY,MX,MZ] = meshgrid(AY,AX,AZ);

    check = (Distances(end)/1.01)^2;
    switch UCType
        case {6,8}
            Limit = size(P,1)-1; %Delete point where no joint exists because endpoint is in middle of strut after mirroring
            
        otherwise
            Limit = size(P,1);
    end
    for i = 1:Limit  

        % Create matrix that specifies each point in our lattice's distance to
        % specified point.
        dmat = ((P(i,1)-MX).^2+(P(i,2)-MY).^2+(P(i,3)-MZ).^2); 
        for x=1:r
            for y = 1:c
                for z = 1:h
                    if dmat(x,y,z)<check
                        if AM(x,y,z)<1
                            AM(x,y,z)=1;
                        end
                    end
                end
            end
        end
    end

end