% Description: Displays Latice
% Parent Function: Main_LatticeGenerator_Simple
% Child Function: 
% Brown Research Group 
% Author: Kelsey Snapp
% Date  : April 4, 2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Revision: 
% Date             Author         Brief Description 
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function DisplayLattice(AM,i)
[r,c,h] = size(AM) ;
X = [1:r];
Y = [1:c];
Z = [1:h];
[MY,MX,MZ] = meshgrid(Y,X,Z);

    figure(i);
    s = isosurface(MY,MX,MZ,AM,0.5);
    h = patch(s,'FaceColor','g');
    s = isocaps(MY,MX,MZ,AM,0.5);
    h = patch(s,'FaceColor','g');
    view (10,45);
    axis equal tight;
    %camlight; lighting phong;
    title('SPATIALLY-VARIANT LATTICE');
    
    
end