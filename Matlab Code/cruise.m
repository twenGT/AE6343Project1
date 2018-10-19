function [ betaf, W, TSL2WTO, leg ] = cruise( betai, WTO, S, h, range, V, type )

global WTO2S

n = 10;
hCr = h;
WCr = zeros(1,n+1);
WCr(1) = betai*WTO;
dt = range*6076.115/V/n;

[~, ~, rho, a] = atmData(hCr);
MCr = V/a;

for i = 1:n
    CL = liftCoeff(WCr(i), S, hCr, V, 1);
    [CD, K1, CD0] = dragCoeff(CL, MCr, type);
    WCr(i+1) = WCr(i)*exp(-TSFC(MCr, hCr, 3, type)*CD/CL*dt);
end

W = WCr(end);
betaf = W/WTO;

q = .5*rho*V^2;

[~, alpha] = thrust(MCr, 1, hCr, 1);

TSL2WTO = (betaf/alpha)*((K1*betaf/q)*(WTO2S) + CD0./((betaf/q)*WTO2S));

leg = 'Cruise';

end

