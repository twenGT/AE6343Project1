clc; clear all; close all

%|0|Initial|1|Pre-takeoff|2|Take off acceleration|3|Acclerating climb
%|4|Cruise climb|5|Loiter|6|Cruise climb|7|Combat|8|Cruise|9|Loiter
%|10|Landing|11|Max speed at SL|12|

designParametersF86L;

global type

betaGuess = [1 1 0.99 0.94 0.92 0.83 0.82 0.81 0.79 0.73 0.73 0.98];
WTOGuess = 18000;
totalLeg = numel(betaGuess) - 2;

j = 1;
dWTO = 1;

while abs(dWTO) > 1E-1
    
    i = 1;
    
    if j == 1
        dbeta = 1;
        beta = betaGuess;
        WTO(j) = WTOGuess;
    end
    
    if abs(dbeta) > 1E-3
        while abs(dbeta) > 1E-3
            if i == 1
                betaIter(i,:) = beta;
            end
            [ TSL2WTO, WTO2SLD ] = F86LCA( betaIter(i,:) );
            [ TSL2WTO_OPT, WTO2S_OPT ] = designPt( TSL2WTO, WTO2SLD );
            [ betaIter(i+1,1:end-1) ] = F86LMA( TSL2WTO_OPT, WTO2S_OPT, totalLeg );
            betaIter(i+1,end) = 0.98;
            dbeta = betaIter(i+1,end-1) - betaIter(i,end-1);
            i = i + 1;
        end
        beta = betaIter(end,:);
    end
    
    [ ~, WE2WTO ] = weights( WTO(j) );
    [ WTOnew ] = WTOCalc( WE2WTO, 1-beta(1,end-1), WTO(j) );
    dWTO = WTOnew - WTO(j);
    WTO(j+1) = (WTO(j) + WTOnew)/2;
    j = j + 1;
    
end

CAPlot( TSL2WTO, TSL2WTO_OPT, WTO2S_OPT, WTO2SLD, type );

output( TSL2WTO_OPT, WTO2S_OPT, WTO(end), 0, 0, beta, type );