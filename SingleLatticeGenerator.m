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

%% Design Inputs

% Select type of unit cell  
    % 5: standard Octet Lattice.
    % 6: Reinforced Octet
    % 7: Octa
    % 8: Reinforced Octahedral
    % 9: circular Octahedral
    % 10: BCC
latticeFamily = 5;

% Select sample name
sampleName = 'Sample';

% Select ID number
ID = 2;

% Select number of unit cells in the x-y-z directions
xRep = 2;
yRep = 2;
zRep = 2;

% Select size of final lattice in mm
sx = 19; %mm
sy = 19; %mm
sz = 19; %mm

% Select resolution of unit cells (Smaller numbers run quicker but have less detail
unitCellRes = 301; % Suggested 301 for prototype runs and 1001 for final product. Should be odd.
finalLatticeRes = 51; % Suggested 51 for prototype runs and 101 for final product. Should be odd.

% Size of attice features as percentage of unit cell
bendingStrutRadius = 0.05;
stretchingStrutRadius = 0.03;
verticalStrutRadius = 0.04;

% Select fill fraction target
FFTarget = .1;  

% Select strut stretching modifier (0 to infinity)
strutStretch = 1; 
% = 1 means no stretching. 
% < 1 means struts are compressed vertically. 
% > 1 mean struts are stretched vertically

% Vertical fill fraction gradient (0 to infinity)
FFGradient = 0;  %0 means no gradient





%% Necessary Calculations
BSR = round(unitCellRes * bendingStrutRadius);
SSR = round(unitCellRes * stretchingStrutRadius);
VSR = round(unitCellRes * verticalStrutRadius);
inputArray = [ID, latticeFamily, xRep,yRep,zRep,BSR,SSR,VSR,strutStretch,FFGradient];

FLSize = [sx,sy,sz];

 
generate_stl(inputArray,FLSize,sampleName,unitCellRes,finalLatticeRes,FFTarget); 


