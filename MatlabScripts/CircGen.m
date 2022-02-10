% Description: Generates curved Rods through the C mat
% Parent Function: pConnectUCGen
% Child Function: None
% Brown Research Group 
% Author: Kelsey Snapp
% Date  : May 19, 2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Revision: 
% Date             Author         Brief Description 
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function CircleMats = CircGen(circleCenters,circleVectors,resolutionOfUnitCell, strutStretch)
     CircleMats = zeros([resolutionOfUnitCell,size(circleCenters,1)]);
     for i=1:size(circleCenters,1)
        planeVector = circleVectors(i,:)-circleCenters(i,:);    %Finds perpindicular to the plane containing the circular path.
        circleRadius = norm(planeVector);                       %Finds the length of the vector. This encodes the desired radius of the circular path.
         for x=1:resolutionOfUnitCell(1)        %Loop through all points in 3d space with nested forloop
             for y = 1:resolutionOfUnitCell(2)
                 for z = 1:resolutionOfUnitCell(3)
                    centerVector = [x, y, z] - circleCenters(i,:); %Find vector from center of circle to point of interest.
                    projectionVector = dot(planeVector,centerVector)/dot(centerVector,centerVector)*planeVector;  %Finds vector perpindicular to plane that is the same length as the distance of the point from the plane.
                    projectionPoint = [x,y,z] - projectionVector;    %Finds the point on the plane that is closest to the point of interest
                    if projectionPoint == circleCenters(i,:)    %If projected point falls onto center of circle, then you can use right triangle to calculate distance to circle.
                        distance = sqrt(norm(centerVector)^2+circleRadius^2);
                    else
                        circleRay = projectionPoint - circleCenters(i,:);   %Finds vector starting at center of circle and going through the projected pont on the plane.
                        circleRay = circleRay / norm(circleRay); %Normalizes length of vector to unit length
                        closestCirclePoint = circleCenters(i,:) + circleRay*circleRadius; % Finds point on circle that is along ray. This is the point on circle closest to point of interest.
                        finalVector = [x,y,z]-closestCirclePoint; %Finds vector from point of interest to point on circle closest to point of interest.
                        finalVector = finalVector.*strutStretch; %Adjusts final vector by NAdjust scaling to stretch out strut into oval if desired.
                        distance = norm(finalVector);
                    end
                    CircleMats(x,y,z,i) = 1/(distance+1); % Calculates weight at point. 1/divided by value to make farther points weighted less. Add 1 to avoid division by zero.
                 end
             end
         end
     end   
     
end