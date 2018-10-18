function [ betaf, W ] = BCMCruise( betai, WTO, S, V, h, range, type )

global BCM

n = 10;
hCr = h;
WCr = zeros(1,n+1);
WCr(1) = betai*WTO;
%150 nautical miles
dt = range*6076.115/V/n;

for i = 1:n
    CL = liftCoeff(WCr(i), S, hCr, V, 1);
    [CD, ~, ~] = dragCoeff(CL, BCM, type);
    WCr(i+1) = WCr(i)*exp(-TSFC(BCM, hCr, 3, type)*CD/CL*dt);
end

W = WCr(end);
betaf = W/WTO;

end

