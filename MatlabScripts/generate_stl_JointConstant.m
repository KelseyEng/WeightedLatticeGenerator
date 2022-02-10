% Description: Generates Mesh of single lattice
% Parent Function: None
% Child Function: generateAM
% Brown Research Group 
% Author: Kelsey Snapp
% Date  : April 7, 2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Revision: 
% Date             Author         Brief Description 
% 4/27/2020         Kelsey          Updated to use FillFractionSort to have
% more reliable Fill Fraction
%5/11/2020          Kelsey          Updated to use LinAlgEigenSolve
%5/12/2020          Kelsey          Made Mats with vertical componenets
%5/17/2020          Kelsey          Added oval beams by stretch (UCSwitch7)
%5/19/2020          Kelsey          Added I-beam (UCSwitch8)
%6/7/2020           Kelsey          Added replication, stl support, die cut, InterpMatDown
%6/12/2020          Kelsey          Added Support Struts
%6/15/2020          Kelsey          Add Fsize adjust for surface area correction.
%6/25/2020          Kelsey          Added CheckPreviousCalculations and LinGuess
%6/25/2020          Kelsey          Added Eighths Support
%7/5/2020           Kelsey          Added StretchConstant and got rid of full (non Eighths) option
%7/8/2020           Kelsey          Changed back to R values as input
%7/15/2020          Kelsey          Converted to Function
%9/30/2020          Kelsey          Add vertical Fill Fraction Sweep
%11/8/2020          Kelsey          Rewrote huge sections of code to unify and simplify variables.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function generate_stl_JointConstant(inputData,sizeOfFinalLattice,ID,resolutionOfUnitCell,fillFractionTarget)
    inputData = sortrows(inputData,[2,9]); %Sorts input by UCType and then StrutStretch so that there are less switching of UCs, saving significant time
    UCTypeList = inputData(:,2);
    replicationList = inputData(:,3:5); %(x,y,z)
    strutRadiusList = [inputData(:,6:8)]; 
    strutStretchList = inputData(:,9);
    IDNumberList = inputData(:,1);
    ZAdjustToFillFractionList = inputData(:,10);
    
    filename_latticeStats = sprintf('LatticeStats%s.xlsx',ID);
    try
        latticeStats = xlsread(filename_latticeStats);
    end

    folder = fileparts(which(mfilename));   % Determine where your m-file's folder is.
    addpath(genpath(folder));  % Add that folder plus all subfolders to the path.

    %%%%%
    VERSION = 7;
    timeTemp = tic;
    %What program will do
        LINEARALGEBRAGUESS = 0; % Set to 1 to use linear algebra to decrease the number of unit cells generated. Good for large Unit Cells.
        INTERPOLATEDOWN = 1; %Set to 1 to decrease resolution beforing building AM from UC.
        REPLICATEMATS = 1; % Set to 1 to Replicate Unit Cell into Lattice
        CAPENDS = 0; % Set to 1 to round off ends of lattice 
        CRISPTOPANDBOTTOM = 0; %Set to 1 to make top and bottom interface sharper. Can be helpful for FEA.
        GENERATESUPPORTMAT = 1; % Set to one to create support struts between bottom and box bottom to facillitate removal
        MESH = 0; % set to 1 to create mesh
        BOX = 2; % Set to 0 for no box, 1 for box, 2 for floor
            BOXWIDTH = 6; % Set width of box in points
        SHOWLATTICE = 0; %Show Lattice based on voxel matrix?
        SAVESTL = 1;   % set to 1 to save file in STL format
        SAVEUCSTL = 0;  %set to 1 to save UC in STL format
                


    % Resolution of Unit Cell
    resolutionOfFinalLattice = [51,51,51];
    resolutionOfUnitCell = ones(1,3)*resolutionOfUnitCell;


    % Select type of unit cell  
        % 5: standard Octet Lattice.
        % 6: Reinforced Octet
        % 7: Octa
        % 8: Reinforced Octa
        % 9: circular Octa
        % 10: BCC

    %Mesh Parameters
    MeshSurfaceMax = 2; %Maximum surface triangle area for tetrahedral mesh
    MeshVolMax = 30;    %Maximum volume of tetreheadral for mesh
    jointRadius = 40; %Set initial joint Radius

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Main Section 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    UCTypeLoaded = 0; %Set to 0 initially to denote that nothing is currently loaded
    strutStretchLoaded = 0; %Set to 0 initially to denote that nothing is currently loaded
    for i = 1:length(IDNumberList)
        tic
        sizeOfFinalLatticeZAdjusted = sizeOfFinalLattice(3); %Z  
        %%Load or generate mat files
        
        if UCTypeList(i) ~= UCTypeLoaded || strutStretchList(i) ~= strutStretchLoaded
            if UCTypeLoaded ~= 0
                save(filename_resmat,'fillFractionResultsMatrix')  %Save previous record of calculations if switching to new one. If loading first mat, nothing to save.
            end
            
            [RodMats, JointMats,UCPoints] = pConnectUCGen(resolutionOfUnitCell,UCTypeList(i), [1,1,strutStretchList(i)]);  % Creates Analog Unit Cell from points and connection matrix
            UCTypeLoaded = UCTypeList(i);  %Designates current Unit Cell so that it does not reload UC if there is no change. 
            strutStretchLoaded = strutStretchList(i);
                      
            % Load mat that will track Fill Fraction Results to avoid duplication of work.
            filename_resmat = sprintf('MatFiles/fillFractionResultsMatrixX%.0fY%.0fZ%.0fUC%.0fNZAdjust%.0f.mat',resolutionOfUnitCell(1),resolutionOfUnitCell(2),resolutionOfUnitCell(3),UCTypeList(i),strutStretchList(i)*10);
            if isfile(filename_resmat)
                load(filename_resmat)
            else
                fillFractionResultsMatrix = zeros(1,9);
            end
        end


        %%Guess jointRadius from previous calculations


        if LINEARALGEBRAGUESS
            if size(fillFractionResultsMatrix,1) > 1
                if fillFractionResultsMatrix(1,1) == 0
                    fillFractionResultsMatrix(1,:) = [];
                end
                jointRadius = LinGuess(fillFractionResultsMatrix,fillFractionTarget,strutRadiusList(i,:));
            end
        end

        
        
        
        
        Distances = GetDistanceValues(UCTypeList(i),strutRadiusList(i,:),jointRadius);  
        finalFillFraction = CheckPreviousCalculations(UCTypeList(i), resolutionOfUnitCell, strutRadiusList(i,:), jointRadius, fillFractionResultsMatrix);    
        if finalFillFraction == 0  %If there was not previous calculations, find out Fill Fraction of current strut values
            [~,finalFillFraction,~] = LinAlgEigenSolve(resolutionOfUnitCell,Distances,RodMats, JointMats,UCTypeList(i),UCPoints); % Creates Analog Matrix from Eigen Mats  
            fillFractionResultsMatrix(end+1,:)= saveRFFResMat(UCTypeList(i), resolutionOfUnitCell, strutRadiusList(i,:), jointRadius, finalFillFraction);
        end    

        %Loop to find Fill Fraction
            whileVarFillFraction = finalFillFraction-fillFractionTarget; %This variable is the variable that is optimized in the while loop. We are trying ot get it as close to zero as possible.
            whileAdjustmentValue = .4; %This is the weight of the adjustment. It changes as you get closer to the target.
            switchVar = 0; % Keeps track of direction you are going so you know when you have switched.
            count = 1; %This counts how many iterations of the loop you have done
            countLimit = 100;  %Sets the maximum amount of iterations you want to do.
            switchCountVar = 0;   %This counts how many times you have gone past the target.
            switchLimit = 10;   %Sets the maximum amount of times you want to go past the target.
            whileRes = zeros(2,countLimit)+10; %Creates matrix to track results. That way at the end you can find the closest, which may not be the last.
            whileRes(:,count)= [jointRadius;whileVarFillFraction]; %Keeps track of first data point
            while abs(whileVarFillFraction)>.0001 && count<countLimit && switchCountVar < switchLimit
                if whileVarFillFraction<0   %Underweight
                    if switchVar == -1  %You have switched from overweight
                        whileAdjustmentValue = whileAdjustmentValue*.3; %Lower adjustment value to get closer to value
                        switchCountVar = switchCountVar + 1;    %Iterate your switch count variable
                    else    %You have not switched (previous round was also underweight)
                        whileAdjustmentValue = whileAdjustmentValue*1.3;    %Raise your adjustment value to speed up movement to target
                    end
                    switchVar = 1;  %Set variable to indicate that this round you were underweight.
                else    %Overweight
                    if switchVar == 1   %You have switched from underweight
                        whileAdjustmentValue = whileAdjustmentValue*.3; %Lower adjustment value to get closer to value
                        switchCountVar = switchCountVar + 1; %Iterate your switch count variable
                    else %You have not switched (previous round was also overweight)
                        whileAdjustmentValue = whileAdjustmentValue*1.3;   %Raise your adjustment value to speed up movement to target
                    end
                    switchVar = -1; %Set variable to indicate that this round you were overweight.
                end
                strutRadiusList(i,2) = strutRadiusList(i,2) + whileAdjustmentValue*switchVar; %Adjust joint radius by the adjustment value. SwitchVar gives direction that you are going.
                if strutRadiusList(i,2)<20 %If jointRadius would round to zero or below, make it round to 1. 0 value screws things up.
                    strutRadiusList(i,2) = 20;
                end
                Distances = GetDistanceValues(UCTypeList(i),strutRadiusList(i,:),jointRadius); 
                finalFillFraction = CheckPreviousCalculations(UCTypeList(i), resolutionOfUnitCell, strutRadiusList(i,:), jointRadius, fillFractionResultsMatrix);
                if finalFillFraction == 0
                    [~,finalFillFraction,~] = LinAlgEigenSolve(resolutionOfUnitCell,Distances,RodMats, JointMats,UCTypeList(i),UCPoints); % Creates Analog Matrix from Eigen Mats  
                    fillFractionResultsMatrix(end+1,:)= saveRFFResMat(UCTypeList(i), resolutionOfUnitCell, strutRadiusList(i,:), jointRadius, finalFillFraction);
                end    
                whileVarFillFraction = finalFillFraction-fillFractionTarget;
                count = count + 1;
                whileRes(:,count)= [jointRadius;whileVarFillFraction];
            end

        %Create Final UC based on loop findings
            [~,indWhileRes] = min(abs(whileRes(2,:))); %Pull the closest value that you found in the while loop (closes fill fraction to target).
            jointRadius = whileRes(1,indWhileRes);  %Set that joint radius value to current value.
            Distances = GetDistanceValues(UCTypeList(i),strutRadiusList(i,:),jointRadius); 
            [UC,finalFillFraction,~] = LinAlgEigenSolve(resolutionOfUnitCell,Distances,RodMats, JointMats,UCTypeList(i),UCPoints); % Creates Analog Matrix from Eigen Mats  






         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% INTERP DOWN
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
        if INTERPOLATEDOWN
                UC = InterpMatDown(UC,ceil(resolutionOfUnitCell./2),ceil(resolutionOfFinalLattice./2)); 

        end


        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% Flip UC Eighth to make full UC
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   

        UC = cat(1,UC,flip(UC,1));
        UC(ceil(size(UC,1)/2),:,:) = [];
        UC = cat(2,UC,flip(UC,2));
        UC(:,ceil(size(UC,2)/2),:) = [];
        UC = cat(3,UC,flip(UC,3));
        UC(:,:,ceil(size(UC,3)/2)) = [];


        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% Save UC STL
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
        if SAVEUCSTL
            filename_stl = sprintf('%s%.0fUC.stl',ID,IDNumberList(i)); % Creates Name for STL
            SaveLattice(UC,10,10,10,filename_stl)
        end

                
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% REPMAT
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if REPLICATEMATS
            disp('replicating')
                AM = zeros((size(UC,1)-1)*replicationList(i,1)+1,(size(UC,2)-1)*replicationList(i,2)+1, (size(UC,3)-1)*replicationList(i,3)+1); % Set up AM so that we don't change size repeatedly.
                AM(1:end-1,1:end-1,1:end-1) = repmat(UC(1:end-1,1:end-1,1:end-1),replicationList(i,1),replicationList(i,2),replicationList(i,3)); %delete inner row to avoid duplication at joinder.
                AM(end,:,:) = AM(1,:,:); %copy x1 to xend to replace deleted row from line above.
                AM(:,end,:) = AM(:,1,:); %repeat in y
                AM(:,:,end) = AM(:,:,1); %repeate in z
            disp('done replicating')
        else
            AM = UC;
        end
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% Z Layer Fill Fraction Transformation
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
        if ZAdjustToFillFractionList(i) ~= 0
            ZHeight = size(AM,3); %Finds how many layers there are in the z direction for our lattice
            ZTransformation = linspace(ZAdjustToFillFractionList(i)/2,-ZAdjustToFillFractionList(i)/2,ZHeight); %Creates an array that spans the gap specified by ZSweep
            ZTransformation = reshape(ZTransformation,1,1,ZHeight); % Changes array to go in the 3rd dimension (z-layer)
            AM = AM + ZTransformation;  %Add Z Transformation to AM. Matlab automatically applies it equally accross the layer.
            
            AM = FFAdjust(AM,fillFractionTarget);
            
            finalFillFraction = sum(sum(sum(AM>=.5)))/numel(AM);
            
        end
        
        
        


        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% CAPMATENDS
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if CAPENDS
            CapMat1 = UC(:,:,1:round(r1/4));
                if REPLICATEMATS ==1
                CapMat1 = repmat(CapMat1,replicationList(i,1),replicationList(i,2),1);
            elseif REPLICATEMATS ==2
                [CapMat1, ~] = MineCraftRep(CapMat1,replicationList(i,1),replicationList(i,2),1,CapMatCorner,CapMatEdge);
            end
            AM = cat(3,flip(CapMat1,3), AM, CapMat1);
        end


        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% CRISPTOPBOTTOM
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if CRISPTOPANDBOTTOM
             AM(:,:,end)=AM(:,:,end)>=.5; % Set top matrix to binary to make crisper top when meshing
             AM(:,:,1)=AM(:,:,1)>=.5; % Set bottom matrix to binary to make crisper top when meshing
        end



        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% SUPPORTMAT
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

        if GENERATESUPPORTMAT
            switch UCTypeList(i)
                case {5,6}  %This method creates struts of a certain size to act as support beams, with a flat bottom.
                    SupportMat = BuildSupports(AM,resolutionOfFinalLattice,ceil(UCPoints.*(resolutionOfFinalLattice./resolutionOfUnitCell)),5);
                    if REPLICATEMATS ==1
                        SupportMat2 = zeros((size(SupportMat,1)-1)*replicationList(i,1)+1,(size(SupportMat,2)-1)*replicationList(i,2)+1, (size(SupportMat,3))); % Set up AM so that we don't change size repeatedly.
                        SupportMat2(1:end-1,1:end-1,:) = repmat(SupportMat(1:end-1,1:end-1,:),replicationList(i,1),replicationList(i,2),1);
                        SupportMat2(end,:,:) = SupportMat2(1,:,:); %copy x1 to xend to replace deleted row from line above.
                        SupportMat2(:,end,:) = SupportMat2(:,1,:); %repeat in y
                    else
                        SupportMat2 = SupportMat;
                    end
                otherwise
                    SupportMat2 = repmat(AM(:,:,1),1,1,round(size(AM,3)/5)); %Takes bottom layer of lattice and replicates it down to make it a support. Ensures that there will be no supported parts of the base, but it probably not the best solution for lattices that have struts lying along the bottom surface.
            end
            AM = cat(3,SupportMat2,AM);
        end





        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% Generate Mesh
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%       
        if MESH    
            filename_inp = sprintf('%S%.0f.inp',ID,IDNumberList(i)); % Creates Name for Mesh
            GenerateMesh(AM,filename_inp,MeshSurfaceMax,MeshVolMax,sizeOfFinalLattice,resolutionOfUnitCell);  % Generates Tetrahedral Mesh from Lattice
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% Add Box
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    

        if BOX 
            [~,~,z1]=size(AM);
            AM = AddBox(AM,BOXWIDTH,BOX);
        end



        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% SHOW LATTICE?
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    

        if SHOWLATTICE
            DisplayLattice(AM,i) % Displays Lattice
        end


        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% SAVE LATTICE
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        if SAVESTL
            filename_stl = sprintf('%s%.0f.stl',ID,IDNumberList(i)); % Creates Name for STL
            if BOX ==2
                [~,~,z2]=size(AM);
                sizeOfFinalLatticeZAdjusted = sizeOfFinalLattice(3)*z2/z1;
            end
            SaveLattice(AM,sizeOfFinalLattice(1),sizeOfFinalLattice(2),sizeOfFinalLatticeZAdjusted,filename_stl)
        end    


        timegen = toc  
        latticeStats(IDNumberList(i),:)=[IDNumberList(i),sizeOfFinalLattice,resolutionOfUnitCell,resolutionOfFinalLattice,fillFractionTarget,finalFillFraction,MeshSurfaceMax,MeshVolMax,timegen,UCTypeList(i),replicationList(i,:), strutRadiusList(i,:), jointRadius, strutStretchList(i),ZAdjustToFillFractionList(i)];
        fprintf('%.0f lattices remaining\n',length(IDNumberList)-i)
    end


    xlswrite(filename_latticeStats,latticeStats);  % Write Excel file with relevant

    save(filename_resmat,'fillFractionResultsMatrix')
  

    toc(timeTemp)


end