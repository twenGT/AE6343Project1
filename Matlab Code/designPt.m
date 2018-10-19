function [ WTO2SOPT ] = designPt( TSL2WTO, WTO2SLD )

global WTO2S

[rowNum, ~] = size(TSL2WTO);

for i = 1:rowNum - 3
    TSL2WTO_PostTO(i,:) = TSL2WTO{i+2,1};
end

TSL2WTO_TO = TSL2WTO{2,1};

diff = abs(TSL2WTO_PostTO - TSL2WTO_TO);

[~,Ind_diff] = min(diff, [], 2);

for i = 1:rowNum - 3
    intercept(i) = TSL2WTO_PostTO(i,Ind_diff(i));
end

[~,Ind_inter] = max(intercept);

WTO2SCalc = WTO2S(Ind_diff(Ind_inter));

if WTO2SCalc > WTO2SLD
    WTO2SOPT = WTO2SLD - 0.5;
else
    WTO2SOPT = WTO2SCalc;
end

end

