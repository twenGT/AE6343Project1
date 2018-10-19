function [ betaf, W, TSL2WTO, leg ] = loiter( betai, WTO, S, h, t, type)
%Loiter time t in minutes

global VCruise
global WTO2S

n = 10;
hL = h;
WL = zeros(1,n+1);
WL(1) = betai*WTO;
dt = t*60/n;

[~, ~, rho, a] = atmData(hL);
ML = VCruise/a;
CL = liftCoeff(WL(1), S, hL, VCruise, 1);
[~, K1, CD0] = dragCoeff(CL, ML, type);

for i = 1:n
    WL(i+1) = WL(i)*exp(-TSFC(ML, hL, 4, type)*sqrt(4*CD0*K1)*dt);
end

W = WL(end);
betaf = W/WTO;

q = .5*rho*VCruise^2;

[~, alpha] = thrust(ML, 1, hL, 1);

TSL2WTO = (betaf/alpha)*((K1*betaf/q)*(WTO2S) + CD0./((betaf/q)*WTO2S));

leg = 'Loiter';

end

