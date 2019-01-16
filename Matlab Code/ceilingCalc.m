function [ hCeiling ] = ceilingCalc( TSL2WTO, WTO2S, type )

global BCM

h = linspace(30000,60000,201);

for i = 1:numel(h)
    [~, ~, rho(i), a(i)] = atmData(h(i));
    [~, alpha(i)] = thrust(BCM, 0, h(i), 1);
end

beta = 0.9;
V = a*BCM;
[ ~, K1, CD0 ] = dragCoeff(0, BCM, type);

RC = V.*(alpha/beta*TSL2WTO - 1/2*rho.*V.^2/(beta*WTO2S)*CD0 - (beta*WTO2S)*2*K1./(rho.*V.^2))*60;

diff = RC - 500;
[~,Ind_diff] = min(abs(diff));

hCeiling = h(Ind_diff);

end