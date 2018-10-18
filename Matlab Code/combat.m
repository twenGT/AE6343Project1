function [ betaf, W ] = combat( betai, WTO, S, h, V, t, loadFactor, type )
%Duration t in minutes

n = 10;
hCb = h;
WCb = zeros(1,n+1);
WCb(1) = betai*WTO;
dt = t*60/n;

[~, ~, ~, a] = atmData(hCb);
MCb = V/a;

for i = 1:n
    CL = liftCoeff(WCb(i), S, hCb, V, loadFactor);
    [CD, ~, ~] = dragCoeff(CL, MCb, type);
    WCb(i+1) = WCb(i)*exp(-TSFC(MCb, hCb, 2, type)*CD/CL*dt);
end

W = WCb(end);
betaf = W/WTO;

end

