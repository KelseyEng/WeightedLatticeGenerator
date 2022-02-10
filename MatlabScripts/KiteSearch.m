% Description: Creates a search area within a unit cell space.
% Parent Function: None
% Child Function: 
% Brown Research Group 
% Author: Kelsey Snapp
% Date  : November 8, 2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Revision: 
% Date             Author         Brief Description 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all 
close all
clc


resolutionOfUnitCell = [201,201,201];
resolutionOfFinalLattice = [51,51,51];
UCType = 6;
minimumStrutValue = 3;
fillFractionTarget = .1;
jointRadius = minimumStrutValue;
strutRadius = [1,1,1]*minimumStrutValue;
strutStretchMaxValue = 3;
zRep = 2;

[RodMats, JointMats,UCPoints] = pConnectUCGen(resolutionOfUnitCell,UCType, 1);  % Creates Analog Unit Cell from points and connection matrix
fillFractionResultsMatrix = zeros(0,9);


%% Find midpoint in strut space.
Distances = GetDistanceValues(UCType,strutRadius,jointRadius);
[~,finalFillFraction,~] = LinAlgEigenSolve(resolutionOfUnitCell,Distances,RodMats, JointMats,UCType,UCPoints); % Creates Analog Matrix from Eigen Mats  
fillFractionResultsMatrix(end+1,:)= saveRFFResMat(UCType, resolutionOfUnitCell, strutRadius, jointRadius, finalFillFraction);
while finalFillFraction < fillFractionTarget
    strutRadius = strutRadius + 1;
    Distances = GetDistanceValues(UCType,strutRadius,jointRadius);  
    [~,finalFillFraction,~] = LinAlgEigenSolve(resolutionOfUnitCell,Distances,RodMats, JointMats,UCType,UCPoints); % Creates Analog Matrix from Eigen Mats  
    fillFractionResultsMatrix(end+1,:)= saveRFFResMat(UCType, resolutionOfUnitCell, strutRadius, jointRadius, finalFillFraction);
end

%% Find strut limits
strutRadiusLimit = zeros(1,3);
for i=1:3
    strutRadius = [1,1,1]*floor((fillFractionResultsMatrix(1,5)+fillFractionResultsMatrix(end,5))/2);
    Distances = GetDistanceValues(UCType,strutRadius,jointRadius);  
    [~,finalFillFraction,~] = LinAlgEigenSolve(resolutionOfUnitCell,Distances,RodMats, JointMats,UCType,UCPoints); % Creates Analog Matrix from Eigen Mats  
    while finalFillFraction < fillFractionTarget
        strutRadius(i)=strutRadius(i)+1;
        Distances = GetDistanceValues(UCType,strutRadius,jointRadius);  
        [~,finalFillFraction,~] = LinAlgEigenSolve(resolutionOfUnitCell,Distances,RodMats, JointMats,UCType,UCPoints); % Creates Analog Matrix from Eigen Mats  
    end
    strutRadiusLimit(i) = strutRadius(i)-1;
end

%% Find Z Adjust to Fill Fraction Limit
strutRadius = [1,1,1]*floor((fillFractionResultsMatrix(1,5)+fillFractionResultsMatrix(end,5))/2);
Distances = GetDistanceValues(UCType,strutRadius,jointRadius);  
[UC,~,~] = LinAlgEigenSolve(resolutionOfUnitCell,Distances,RodMats, JointMats,UCType,UCPoints); % Creates Analog Matrix from Eigen Mats
% UC = InterpMatDown(UC,ceil(resolutionOfUnitCell./2),ceil(resolutionOfFinalLattice./2));

% Turn into full UnitCell
% UC = cat(1,UC,flip(UC,1));
% UC(ceil(size(UC,1)/2),:,:) = [];
% UC = cat(2,UC,flip(UC,2));
% UC(:,ceil(size(UC,2)/2),:) = [];
UC = cat(3,UC,flip(UC,3));
UC(:,:,ceil(size(UC,3)/2)) = [];

% Replicate in z direction.
AM = zeros(size(UC,1),size(UC,2),(size(UC,3)-1)*zRep+1);  %Set up AM so that we don't change size repeatedly.
AM(:,:,1:end-1) = repmat(UC(:,:,1:end-1),1,1,zRep); %delete inner row to avoid duplication at joinder.
AM(:,:,end) = AM(:,:,1); %copy deleted face on top part.

breakVar = 1;
ZAdjustToFillFraction = 0;
ZHeight = size(AM,3); %Finds how many layers there are in the z direction for our lattice
while breakVar == 1
    ZAdjustToFillFraction = ZAdjustToFillFraction + .1
    ZTransformation = linspace(-ZAdjustToFillFraction/2,ZAdjustToFillFraction/2,ZHeight); %Creates an array that spans the gap specified by ZSweep. Reverses direction so that it is easier to test.
    ZTransformation = reshape(ZTransformation,1,1,ZHeight); % Changes array to go in the 3rd dimension (z-layer)
    AMAdjusted = AM + ZTransformation;  %Add Z Transformation to AM. Matlab automatically applies it equally accross the layer.
    AMAdjusted = FFAdjust(AMAdjusted,fillFractionTarget);
    checkPoint = getCheckPoint(UCType,resolutionOfUnitCell);
    breakVar = CheckMimimumRadiusAtPoint(AMAdjusted,checkPoint,minimumStrutValue);
end
ZAdjustToFillFractionLimit = ZAdjustToFillFraction-.1;







%% Find Strut Stretch Limits
strutRadius = [1,1,1]*floor((fillFractionResultsMatrix(1,5)+fillFractionResultsMatrix(end,5))/2);
[~,finalFillFraction,~] = LinAlgEigenSolve(resolutionOfUnitCell,Distances,RodMats, JointMats,UCType,UCPoints); % Creates Analog Matrix from Eigen Mats  
strutStretch = 1;

while finalFillFraction < fillFractionTarget && strutStretch <=strutStretchMaxValue+.1
    strutStretch = strutStretch+.1;
    [RodMats, JointMats,UCPoints] = pConnectUCGen(resolutionOfUnitCell,UCType, strutStretch);
    [~,finalFillFraction,~] = LinAlgEigenSolve(resolutionOfUnitCell,Distances,RodMats, JointMats,UCType,UCPoints); % Creates Analog Matrix from Eigen Mats 
end

strutStretchLimit(2) = strutStretch-.1;

strutRadius = [1,1,1]*floor((fillFractionResultsMatrix(1,5)+fillFractionResultsMatrix(end,5))/2);
[~,finalFillFraction,~] = LinAlgEigenSolve(resolutionOfUnitCell,Distances,RodMats, JointMats,UCType,UCPoints); % Creates Analog Matrix from Eigen Mats  
strutStretch = 1;

while finalFillFraction < fillFractionTarget && strutStretch >0
    strutStretch = strutStretch-.1;
    [RodMats, JointMats,UCPoints] = pConnectUCGen(resolutionOfUnitCell,UCType, strutStretch);
    [~,finalFillFraction,~] = LinAlgEigenSolve(resolutionOfUnitCell,Distances,RodMats, JointMats,UCType,UCPoints); % Creates Analog Matrix from Eigen Mats 
end

strutStretchLimit(1) = strutStretch+.1;
if round(strutRadius(1)*strutStretchLimit(1)) < minimumStrutValue
    strutStretchLimit(1)= round(minimumStrutValue/strutRadius(1),1);
end


  














