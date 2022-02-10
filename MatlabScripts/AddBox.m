% Description: Takes 3D lattice and adds a box (box == 1) or bottom plate
%               (box ~=1). Note, function not called if box ==0. Bwidth
%               defines the thickness of the box.
% Parent Function: LatticeGenerator
% Brown Research Group 
% Author: Kelsey Snapp
% Date  : January 15, 2019
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Revision: 
% Date             Author         Brief Description 
% 6/7/2020          Kelsey          Updated to work with AM Matrix
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function AM = AddBox(AM,boxWidth,BoxType)
if BoxType == 1
    %Add Top and bottom
    [x,y,z] = size(AM);
    Ztop0 = boxWidth +1;
    Ztop1 = z + boxWidth;
    Ztop2 = z+1+boxWidth;
    Ztop3 = z + 2*boxWidth;
    SVLT = ones(x,y,boxWidth);
    SVLT(:,:,Ztop0:Ztop1) = AM;
    SVLT(:,:,Ztop2:Ztop3) = ones(x,y,boxWidth);
    AM = SVLT;

    % Add sides along x-axis
    [x,y,z] = size(AM);
    Ztop0 = boxWidth +1;
    Ztop1 = x + boxWidth;
    Ztop2 = x+1+boxWidth;
    Ztop3 = x + 2*boxWidth;
    SVLT = ones(boxWidth,y,z);
    SVLT(Ztop0:Ztop1,:,:) = AM;
    SVLT(Ztop2:Ztop3,:,:) = ones(boxWidth,y,z);
    AM = SVLT;

    % Add sides along y-axis
    [x,y,z] = size(AM);
    Ztop0 = boxWidth +1;
    Ztop1 = y + boxWidth;
    Ztop2 = y+1+boxWidth;
    Ztop3 = y + 2*boxWidth;
    SVLT = ones(x,boxWidth,z);
    SVLT(:,Ztop0:Ztop1,:) = AM;
    SVLT(:,Ztop2:Ztop3,:) = ones(x,boxWidth,z);
    AM = SVLT;
else
    %Just add bottom layer (type of raft)
    [x,y,z] = size(AM);
    Ztop0 = boxWidth +1;
    Ztop1 = z + boxWidth;
    SVLT = ones(x,y,boxWidth);
    SVLT(:,:,Ztop0:Ztop1) = AM;
    AM = SVLT;
    
end