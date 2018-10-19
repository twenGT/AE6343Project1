function [ betaf, W, TSL2WTO, leg ] = combat( betai, WTO, S, h, V, t, loadFactor, type )
%Duration t in minutes

global VCombat
global WTO2S

n = 10;
hCb = h;
WCb = zeros(1,n+1);
WCb(1) = betai*WTO;
dt = t*60/n;

[~, ~, rho, a] = atmData(hCb);
MCb = V/a;

for i = 1:n
    CL = liftCoeff(WCb(i), S, hCb, V, loadFactor);
    [CD, K1, CD0] = dragCoeff(CL, MCb, type);
    WCb(i+1) = WCb(i)*exp(-TSFC(MCb, hCb, 2, type)*CD/CL*dt);
end

W = WCb(end);
betaf = W/WTO;

q = .5*rho*VCombat^2;

[~, alpha] = thrust(MCb, 1, hCb, 2);

TSL2WTO = (betaf/alpha)*((loadFactor*K1*betaf/q)*(WTO2S) + CD0./((betaf/q)*WTO2S));

leg = 'Combat';

end

