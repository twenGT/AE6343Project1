function [ TSL2WTO_OPT, WTO2S_OPT ] = designPt( TSL2WTO, WTO2SLD )
%In TSL2WTO, last row is max speed constraint
%It is assumed to be the most restrictive
%the rest are mission constraints

global WTO2S

%Get the total number of constraints
[rowNum, ~] = size(TSL2WTO);

%Max speed constraint
TSL2WTO_MaxSpeed = TSL2WTO{end,1};

%Other constraints
for i = 1:rowNum-1
    TSL2WTO_Other(i,:) = TSL2WTO{i,1};
end
diff = abs(TSL2WTO_Other - TSL2WTO_MaxSpeed);

%Find the indicies of interceptions
[~,Ind_diff] = min(diff, [], 2);

%Find the TSL2WTO values at those interceptions
for i = 1:rowNum - 1
    intercept(i) = TSL2WTO_Other(i,Ind_diff(i));
end

%Find the max value of TSL2WTO
[~,Ind_inter] = max(intercept);

%Find the  value of WTO2S that corresponds to max TSL2WTO
WTO2SCalc = WTO2S(Ind_diff(Ind_inter));

if WTO2SCalc > WTO2SLD
    WTO2S_OPT = WTO2SLD - 0.5;
else
    WTO2S_OPT = WTO2SCalc;
end

TSL2WTO_OPT = TSL2WTO_Other(Ind_inter,Ind_diff(Ind_inter))*1.05;

end

