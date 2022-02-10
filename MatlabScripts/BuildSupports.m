% Description: Generates Support Struts at bottom nodes to aid printing on
% Form 3
% Parent Function: Main_UnitCellTester
% Child Function: None
% Brown Research Group 
% Author: Kelsey Snapp
% Date  : June 12, 2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Revision: 
% Date             Author         Brief Description 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function SupportMat = BuildSupports(AM,resolutionOfUnitCell,P,radiusOfSupportStruts)
heightOfSupports = round(size(AM,3)/5);  %Find height for support
Ps = P(P(:,3) == 1,:);      %Find points that are on bottom of lattice
LP = size(Ps,1);            %Find how many points are on bottom of lattice
Ps = [Ps; Ps + [zeros(size(Ps,1),2) ones(size(Ps,1),1)*heightOfSupports]]; %Define top and bottom points of supports
C = zeros(LP,2); %Create empty connection matrix
for i = 1:LP
    C(i,:) = [ i i+LP]; %define connection matrix to connect top and bottom points of supports
end

%%Add Connection rods between points
SupportMat = zeros(resolutionOfUnitCell(1),resolutionOfUnitCell(2), heightOfSupports);    
     for i=1:size(C,1)
        linep1 =[Ps(C(i,1),1),Ps(C(i,1),2),Ps(C(i,1),3)];
        linep2 = [Ps(C(i,2),1),Ps(C(i,2),2),Ps(C(i,2),3)];
        linev = linep1-linep2;
        lengthLine = norm(linev);
         for x=1:resolutionOfUnitCell(1)
             for y = 1:resolutionOfUnitCell(2)
                 for z = 1:heightOfSupports
                    temp = (pdist(linev,lengthLine,linep1,[x,y,z])); % Calculates distance from line
                    if temp < radiusOfSupportStruts
                        SupportMat(x,y,z) = 1; % replaces value if greater than original
                    end
                 end
             end
         end
     end
      SupportMat = SupportMat + flip(SupportMat,1);
      SupportMat = SupportMat + flip(SupportMat,2);
end
