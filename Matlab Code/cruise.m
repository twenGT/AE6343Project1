function [ betaf, W ] = cruise( betai, WTO, S, h, range )


global VCruise

n = 10;
hCr = h;
WCr = zeros(1,n+1);
WCr(1) = betai*WTO;
dt = range*6076.115/VCruise/n;

[~, ~, ~, a] = atmData(hCr);
MCr = VCruise/a;

for i = 1:n
    CL = liftCoeff(WCr(i), S, hCr, VCruise, 1);
    [CD, ~, ~] = dragCoeff(CL, MCr, 1);
    WCr(i+1) = WCr(i)*exp(-TSFC_F86L(MCr, hCr, 3)*CD/CL*dt);
end

W = WCr(end);
betaf = W/WTO;


end

