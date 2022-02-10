function generate_abaqusinp(filename_inp,nodes,elems,E,v,dispz)
% Description: code converts a mesh to a .inp file for compression test 
% in abaqus 

%% writing inp file with compression test 

%disp('Writing full .inp file') 

fidinp=fopen(filename_inp,'w');

fprintf(fidinp,'*Heading\n');

fprintf(fidinp,'*Preprint, echo=NO, model=NO, history=NO, contact=NO\n');

%fprintf(fidinp,'*Part, name=Part-1\n');

fprintf(fidinp,'*node\n');

fprintf(fidinp,'%i,%4.3f,%4.3f,%4.3f\n',nodes');

fprintf(fidinp,'*element, type=c3d4,elset=elemall\n');

fprintf(fidinp,'%i,%i,%i,%i,%i\n',elems');

%fprintf(fidinp,'*element, type=S3R,elset=elemall2\n');

%fprintf(fidinp,'%i,%i,%i,%i\n',faces');

%fprintf(fidinp,'*ELSET, ELSET=elemall\n');

%fprintf(fidinp,'elemall1,elemall2\n');

fprintf(fidinp,'*Solid Section, elset=elemall, material=PLA\n'); 

fprintf(fidinp,',\n'); 

%% top and bottom nodes 

% round node coordinates 

nodes = round(nodes,2);

% top boundary conditions: top node set 

z_top = max(nodes(:,4)); 

%topnode = nodes(nodes(:,4) == round(z_top,2) ,1); 
topnode = nodes(nodes(:,4) >= round(z_top,2)*0.99 ,1); 

fprintf(fidinp,'*NSET, NSET= topnode\n');
   
fprintf(fidinp,'%d,\n',topnode');

% bottom boundary conditions: bot node set 

z_bot = min(nodes(:,4));

%botnode = nodes(nodes(:,4) == round(z_bot,2) ,1); 
botnode = nodes(nodes(:,4) <= round(z_bot,2)+0.5 ,1); 

fprintf(fidinp,'*NSET, NSET= botnode\n');
    
fprintf(fidinp,'%d,\n',botnode');

%% compression test 
fprintf(fidinp,'**\n');
fprintf(fidinp,'**\n');
fprintf(fidinp,'** MATERIALS\n');
fprintf(fidinp,'**\n');
fprintf(fidinp,'*Material, name = PLA\n');
fprintf(fidinp,'*Elastic\n');
fprintf(fidinp,'%d,%d\n',E,v);
%fprintf(fidinp,'*Plastic\n');
%fprintf(fidinp,'56620000, 0.0\n');
%fprintf(fidinp,'84095000, 0.2\n');
fprintf(fidinp,'**\n');
fprintf(fidinp,'**\n');
fprintf(fidinp,'** STEP: Step-Compression\n');
fprintf(fidinp,'**\n');
fprintf(fidinp,'*Step, name=Step-Compression, nlgeom=YES\n');
fprintf(fidinp,'*Static\n');
fprintf(fidinp,'0.2, 1., 1e-05, 1.0\n');
fprintf(fidinp,'**\n');

fprintf(fidinp,'** BOUNDARY CONDITIONS\n');
fprintf(fidinp,'**\n');
fprintf(fidinp,'*Boundary\n');
fprintf(fidinp,'botnode, 3, 3, 0\n');
fprintf(fidinp,'*Boundary\n');
compressionval = ['topnode, 3, 3, ',num2str(dispz),'\n']; 
fprintf(fidinp,compressionval); 
fprintf(fidinp,'*Boundary\n');
bottombc1 = [num2str(botnode(1)),',1,3,0\n'];
fprintf(fidinp,bottombc1);
fprintf(fidinp,'*Boundary\n');
bottombc2 = [num2str(botnode(2)),',1,3,0\n'];
fprintf(fidinp,bottombc2);

fprintf(fidinp,'**\n');
fprintf(fidinp,'** OUTPUT REQUESTS\n');
fprintf(fidinp,'**\n');
fprintf(fidinp,'*Restart, write, frequency=1,overlay\n');
fprintf(fidinp,'**\n');
fprintf(fidinp,'** FIELD OUTPUT: F-Output-1\n');
fprintf(fidinp,'**\n');
fprintf(fidinp,'*Output, field, VARIABLE=PRESELECT\n');
fprintf(fidinp,'**Node Output\n');
fprintf(fidinp,'**U,\n');
fprintf(fidinp,'**Element Output, directions=YES\n');
fprintf(fidinp,'**E, S \n');
fprintf(fidinp,'**\n');
fprintf(fidinp,'** HISTORY OUTPUT: H-Output-1\n');
fprintf(fidinp,'**\n');
fprintf(fidinp,'*Output, history, variable=PRESELECT\n');
fprintf(fidinp,'**EL PRINT, elset=elemall\n');
fprintf(fidinp,'**S,E\n');
fprintf(fidinp,'*Node Print, nset = topnode\n');
fprintf(fidinp,'U, RF, CF\n');
fprintf(fidinp,'*End Step\n');
fclose(fidinp);
%disp('Complete')

%% check the existence of the inp file
% if the inp file does not exist, then wait 

while exist(filename_inp,'file') ~= 2 
    pause(0.1) 
end 

%% return message 

msg = ['Successfully generated .inp file: ',filename_inp];

disp(msg)

end
