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
function radius = checkRadiusAtPoint(AM,P)

[r,c,h] = size(AM);
    % Create Meshgrid to use in calcuations
    AX = [1:r];
    AY = [1:c];
    AZ = [1:h];
    [MY,MX,MZ] = meshgrid(AY,AX,AZ);

    % Create matrix that specifies each point in our lattice's distance to
    % specified point.
dmat = ((P(1)-MX).^2+(P(2)-MY).^2+(P(3)-MZ).^2+1); 

FF = 1;
radius = 0;
radjust = .1;
%loop until sphere includes non-material
while FF==1
    radius = radius +radjust;
    check = radius^2;
    temp = AM(dmat<check);
    if ~isempty(temp)
    FF = sum(temp>.5)/length(temp);
    end
end
% Go back to last radius with all material
radius=radius-radjust;

end


