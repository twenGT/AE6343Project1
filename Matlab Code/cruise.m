function [ betaf, W ] = cruise( betai, WTO, S, h, range, V, type )

n = 10;
hCr = h;
WCr = zeros(1,n+1);
WCr(1) = betai*WTO;
dt = range*6076.115/V/n;

[~, ~, ~, a] = atmData(hCr);
MCr = V/a;

for i = 1:n
    CL = liftCoeff(WCr(i), S, hCr, V, 1);
    [CD, ~, ~] = dragCoeff(CL, MCr, type);
    WCr(i+1) = WCr(i)*exp(-TSFC(MCr, hCr, 3, type)*CD/CL*dt);
end

W = WCr(end);
betaf = W/WTO;


end

