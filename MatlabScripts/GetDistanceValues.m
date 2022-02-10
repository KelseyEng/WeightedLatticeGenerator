% Description: Generates R (radius) values for give parameters
% Parent Function: Main
% Child Function: None
% Brown Research Group 
% Author: Kelsey Snapp
% Date  : July 3, 2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Revision: 
% Date             Author         Brief Description 
%7/5/2020            Kelsey          Fixed R value calculations and made compatible with non cube shapes (Nxu must equal Nyu)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function Distances = GetDistanceValues(UCSwitch,strutRadius,jointRadius)
strutRadius = round(strutRadius);


switch UCSwitch

    case 5
        Distances = [strutRadius(1), strutRadius(1), strutRadius(2), strutRadius(2), jointRadius, jointRadius, jointRadius]; %(in point resolution)
        %UC 5 [edge diagonal beam, interior diagonal beam, interior flat beam, bottom flat beam, corner joint,  side joint, bottom joint]  

    case 6
        Distances = [strutRadius(1), strutRadius(1), strutRadius(2), strutRadius(2), jointRadius, jointRadius, jointRadius, strutRadius(3)]; %(in point resolution)
        %UC 6 [edge diagonal beam, interior diagonal beam, interior flat beam, bottom flat beam, corner joint,  side joint, bottom joint, vertical beam]     

    case 7
        Distances = [strutRadius(1), strutRadius(2), jointRadius, jointRadius]; %(in point resolution)
        %UC 7 [interior diagonal beam, interior flat beam,side joint, bottom joint]  

    case 8
        Distances = [strutRadius(1), strutRadius(2), jointRadius, jointRadius, strutRadius(3)]; %(in point resolution)
        %UC 8 [interior diagonal beam, interior flat beam,side joint, bottom joint, vertical beam] 
        
    case 9
        Distances = [strutRadius(1), strutRadius(2), jointRadius, jointRadius]; %(in point resolution)
        %UC 9 [circular beams, straight (horizontal) beams, side joint, bottom joint] 
        
    case 10
        Distances = [strutRadius(1), jointRadius]; %(in point resolution)
        %UC 10 [beam, joint]        
        
end