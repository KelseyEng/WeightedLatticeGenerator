% Description: Guesses R values based on previous results and linear algebra
% Parent Function: Main
% Child Function: None
% Brown Research Group 
% Author: Kelsey Snapp
% Date  : April 7, 2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Revision: 
% Date             Author         Brief Description 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function jointRadius = LinGuess(RFFResMat,FFTarget,strutRadius)
A = RFFResMat(:,5:8); % Get previous R values
b = RFFResMat(:,9); % Get previous Fill Fraction Results
x = A\b; % Find ratio of R values to Fill Fraction Results using linear algebra


%%Start Guessing r values
bTest = strutRadius*x;
whileVarRGuess = bTest-FFTarget;
whileAdjuster = 1;
switchvar = 0;
count = 1;
countLimit = 100;
bVar = 0;
switchLimit = 5;
whileRes = zeros(2,countLimit)+10;
whileRes(:,count)= [jointRadius;whileVarRGuess];
%%Loop until you find closest guess to Fill Fraction Target (FFTarget)
    while abs(whileVarRGuess)>.001 && count<countLimit && bVar < switchLimit
        if whileVarRGuess<0
            if switchvar == -1
                whileAdjuster = whileAdjuster*.3;
                bVar = bVar + 1;
            else
                whileAdjuster = whileAdjuster*1.3;
            end
            switchvar = 1;
        else
            if switchvar == 1
                whileAdjuster = whileAdjuster*.3;
                bVar = bVar + 1;
            else
                whileAdjuster = whileAdjuster*1.3;
            end
            switchvar = -1;
        end
        jointRadius = jointRadius + whileAdjuster*switchvar;
        if jointRadius<.5
            jointRadius = .5;
        end
        bTest = strutRadius*x;
        whileVarRGuess = bTest-FFTarget;
        whileRes(:,count)= [jointRadius;whileVarRGuess];
        count = count + 1;
    end
    [~,indWhileRes] = min(abs(whileRes(2,:)));
    jointRadius = whileRes(1,indWhileRes);
end