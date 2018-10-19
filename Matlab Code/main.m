clc; clear all; close all

designParametersF86L;

i = 1;
guess(i,:) = [18500 60];
deltaWF = 1;

while abs(deltaWF) > 0.1
    
    [WFinal, beta, TSL2WTO, WTO2SLD] = F86L(guess(i,1), guess(i,1)/guess(i,2));
    
    WTO2SOPT = designPt(TSL2WTO, WTO2SLD);
    
    [WF_av, WE] = weights(guess(i,1));
    
    deltaWF = WF_av - (guess(i,1) - WFinal);
    
    i = i + 1;
    
    guess(i,1) = guess(i-1,1) - deltaWF/2;
    guess(i,2) = WTO2SOPT;
    
end