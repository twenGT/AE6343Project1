clc; clear all; close all

%|0|Initial|1|Pre-takeoff|2|Takeoff acceleration|3|Acclerating climb
%|4|Cruise|5|Rendezvous|6|Refueling Sim|7|Accelerating climb|8|Cruise
%|9|Descend|10|Combat training|11|Cruise climb|12|Cruise|13|Landing
%|14|Reserve (loiter)|15|Max speed at SL|16|

designParametersAPTA;

global type

%               1    2    3    4    5    6    7    8    9   10
betaGuess = [1.00 0.95 0.94 0.91 0.85 0.83 0.82 0.80 0.79 0.79...
             0.74 0.73 0.71 0.70 0.68 0.98];
WTOGuess = 22000;
totalLeg = numel(betaGuess) - 2;

j = 1;
dWTO = 1;

while abs(dWTO) > 1E-1
    
    i = 1;
    dbeta = 1;
    if j == 1
        beta = betaGuess;
        WTO(j) = WTOGuess;
    end
    
    while abs(dbeta) > 1E-5
        if i == 1
            betaIter(i,:) = beta;
            WTO2S_OPT = 85;
        end
        [ TSL2WTO, WTO2SLD ] = APTACA( betaIter(i,:), WTO2S_OPT);
        [ TSL2WTO_OPT, WTO2S_OPT ] = designPt( TSL2WTO, WTO2SLD );
        [ betaIter(i+1,1:end-1) ] = APTAMA( TSL2WTO_OPT, WTO2S_OPT, WTO(j), totalLeg );
        betaIter(i+1,end) = 0.98;
        dbeta = betaIter(i+1,end-1) - betaIter(i,end-1);
        i = i + 1;
    end
    beta = betaIter(end,:);
    
    [ ~, WE2WTO ] = weights( WTO(j) );
    [ WTOnew ] = WTOCalc( WE2WTO, 1-beta(1,end-1), 0);
    dWTO = WTOnew - WTO(j);
    WTO(j+1) = (WTO(j) + WTOnew)/2;
    j = j + 1;
    
end

CAPlot( TSL2WTO, TSL2WTO_OPT, WTO2S_OPT, WTO2SLD, type );

maxRange = rangeAPTA( WTO(end), TSL2WTO_OPT, WTO2S_OPT, beta(end-1) );
hCeiling = ceilingCalc( TSL2WTO_OPT, WTO2S_OPT, type );

output( TSL2WTO_OPT, WTO2S_OPT, WTO(end), maxRange, hCeiling, beta, type );