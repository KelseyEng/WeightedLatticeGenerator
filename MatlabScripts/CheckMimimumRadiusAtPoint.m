% Description: Checks max radius of filled sphere at point supplied
% Parent Function: As needed
% Child Function: None
% Brown Research Group 
% Author: Kelsey Snapp
% Date  : April 21, 2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Revision: 
% Date             Author         Brief Description 
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function result = CheckMimimumRadiusAtPoint(AM,checkPoint,minimumRadius)

    [r,c,h] = size(AM);
    % Create Meshgrid to use in calcuations
    AX = [1:r];
    AY = [1:c];
    AZ = [1:h];
    [MY,MX,MZ] = meshgrid(AY,AX,AZ);

    % Create matrix that specifies each point in our lattice's distance to
    % specified point.
    dmat = ((checkPoint(1)-MX).^2+(checkPoint(2)-MY).^2+(checkPoint(3)-MZ).^2+1); 


    check = minimumRadius^2;
    temp = AM(dmat<check);
    if isempty(temp)
        result = 0;
    else
        FF = sum(temp>.5)/length(temp);
        if FF ==1
            result = 1;
        else
            result = 0;
        end
    end
end


