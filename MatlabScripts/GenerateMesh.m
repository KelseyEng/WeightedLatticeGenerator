% Description: Generates Tetrahedral Mesh for Abacus
% Parent Function: Main_LatticeGenerator
% Child Function: None
% Brown Research Group 
% Author: Kelsey Snapp
% Date  : April 1, 2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Revision: 
% Date             Author         Brief Description 
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function GenerateMesh(AM,filename_inp,MeshSurfaceMax,MeshVolMax,sizeOfFinalLattice,resolutionOfUnitCell)

[nodes,elem,face]=v2m(AM,0.5,MeshSurfaceMax,MeshVolMax);

filename_mat = [filename_inp(1:end-4),'.mat'];

%save(filename_mat,'nodes','elem');

% nodes
% variable name: nodes 
% the nodes matrix should be n by 3
% x: 1st column, y: 2nd column, z: 3rd column
% the code assumes that the specimen is being compressed in the z direction

% elements
% variable name: elems
% the elements matrix should be n by 10 
% the element type assumed in the code is c3d10

elems = elem(:,1:3); 


%% generate abaqus inp file  

%% nodes

% scale nodes to output size

nodeAdjust = sizeOfFinalLattice./resolutionOfUnitCell;
nodeAdjust = repmat(nodeAdjust,size(nodes,1),1);
nodes = nodes.*nodeAdjust;

%plotmesh(nodes,face)

% nodes 

% this adds a node id column
%nodes(nodes<0)=0;
%nodes(nodes>Fsizex)=Fsizex;

%nodes(nodes<0.5) = 0; 
%nodes(nodes>Fsizex*0.99) = Fsizex; 



nodes = [[1:size(nodes,1)]',nodes];


% elements
% this adds an element id column 
elems = elem(:,1:4); 
elems = [[1:size(elems,1)]',elems]; 

% faces 
% this adds a facelement id column 

faces = face(:,1:3);

faces = [[1+elems(end,1):size(faces,1)+elems(end,1)]',faces]; 

% modulus 

E = 301e6;

% poissons' ratio 

v = 0.3; 

% displacement 

dispz = -1.0; 

% save nodes and elems 

save(filename_mat,'nodes','elems');

% generate abaqus inp file 

generate_abaqusinp(filename_inp,nodes,elems,E,v,dispz); 



%viewLattice(elems,nodes,i)


end