% Description: Saves Lattice as an STL
% Parent Function: LatticeGenerator
% Child Function: svlcad
% Brown Research Group 
% Author: Kelsey Snapp
% Date  : January 15, 2019
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Revision: 
% Date             Author         Brief Description 
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This code is derived from code originally written by Dr. Raymond C. Rumpf of University Texas EL Paso
% For more information, see his website: http://www.emlab.utep.edu/scSVL.htm
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function SaveLattice(AM,Sizex,Sizey,Sizez,LName)
    
% CALCULATE GRID
[Nx,Ny,Nz] = size(AM);
dx = Sizex/(Nx-1);
dy = Sizey/(Ny-1);
dz = Sizez/(Nz-1);
xa = [0:Nx-1]*dx;
ya = [0:Ny-1]*dy;
za = [0:Nz-1]*dz;


% MESH THE SURFACE
[F,V] = isosurface(ya,xa,za,AM,0.5);
[FC,VC] = isocaps(ya,xa,za,AM,0.5);

% COMBINE FACES AND VERTICES
F = [ F ; FC + length(V(:,1)) ];
V = [V ; VC ];
clear FC VC;


% SAVE LATTICE TO STL FILE
disp('Creating STL file...'); drawnow;
stlWrite2(LName,F,V);
disp('Done Saving')


end