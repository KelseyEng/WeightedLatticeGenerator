% Description: Generates Lattice
% Brown Research Group 
% Author: Kelsey Snapp
% Date  : 2/9/2022

%Acknowledgements: This Lattice Generation Method was heavliy inspired by
%the work of Dr.  Raymond C. (Tipper) Rumpf from the University of Texas El
%Paso. While ultimately it uses a different principle (combining weighted lattices 
%vs. using fourier series decomposition) to make the lattices,
%many of the variable names and coding conventions were copied from his
%excellent work. A few scripts are borrowed in whole or in part from his work, and
%these scripts are noted accordingly in their separate header. For more
%information, please check out his websites:
%https://empossible.net/academics/svl-short-course/
%https://raymondrumpf.com/research/
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Initialization
clear all
close all
clc

%% Add MatlabScripts Subfolder to Matlab Path
subFolderName = 'MatlabScripts';
addpath(genpath(subFolderName));

%% Design Inputs (These must be the same for all lattices in a batch)
% Select sample name
sampleName = 'TestSamples';

% Select size of final lattice in mm
sx = 38; %mm
sy = 38; %mm
sz = 19; %mm

% Select resolution of unit cells (Smaller numbers run quicker but have less detail
unitCellRes = 301; % Suggested 301 for prototype runs and 1001 for final product. Should be odd.
finalLatticeRes = 51; % Suggested 51 for prototype runs and 101 for final product. Should be odd.

% Select fill fraction target
FFTarget = .1;  


%% Per Lattice Inputs (Define in Excel Sheet)
batchInput = readtable('BatchInput.xlsx');
ID = batchInput.ID;
latticeFamily = batchInput.latticeFamily;
xRep = batchInput.xRep;
yRep = batchInput.yRep;
zRep = batchInput.zRep;
bendingStrutRadius = batchInput.bendingStrutRadius;
stretchingStrutRadius = batchInput.stretchingStrutRadius;
verticalStrutRadius = batchInput.verticalStrutRadius;
strutStretch = batchInput.strutStretch;
FFGradient = batchInput.FFGradient;

%% Necessary Calculations
BSR = round(unitCellRes * bendingStrutRadius);
SSR = round(unitCellRes * stretchingStrutRadius);
VSR = round(unitCellRes * verticalStrutRadius);
inputArray = [ID, latticeFamily, xRep,yRep,zRep,BSR,SSR,VSR,strutStretch,FFGradient];

FLSize = [sx,sy,sz];

 
generate_stl(inputArray,FLSize,sampleName,unitCellRes,finalLatticeRes,FFTarget); 


