clc; clear all; close all

designParametersF86L;

i = 1;
guess(i,:) = [18500 60];
deltaWF = 1;
plotOn = 0;

while (abs(deltaWF) > 0.1) && (abs(deltaWF) < 1E4)
    
    [WFinal, beta, TSL2WTO, WTO2SLD] = F86L(guess(i,1), guess(i,1)/guess(i,2), plotOn);
    
    WTO2SOPT = designPt(TSL2WTO, WTO2SLD);
    
    [WFav, WE] = weights(guess(i,1));
    
    WFreq = guess(i,1) - WFinal;
    deltaWF = WFav - WFreq;
    
    i = i + 1;
    
    guess(i,1) = guess(i-1,1) + deltaWF/2;
    guess(i,2) = WTO2SOPT;
    
    if abs(deltaWF) < 0.1
        plotOn = 1;
        [~, ~, ~, ~] = F86L(guess(i,1), guess(i,1)/guess(i,2), plotOn);
        disp('Solution Converged!');
    end
    
end