function [ betaf, W ] = loiter( betai, WTO, S, h, t )
%Loiter time t in minutes

global VCruise

n = 10;
hL = h;
WL = zeros(1,n+1);
WL(1) = betai*WTO;
dt = t*60/n;

[~, ~, ~, a] = atmData(hL);
ML1 = VCruise/a;
CL = liftCoeff(WL(1), S, hL, VCruise, 1);
[~, CD0K1] = dragCoeff(CL, ML1, 1);

for i = 1:n
    WL(i+1) = WL(i)*exp(-TSFC_F86L(ML1, hL, 4)*sqrt(4*CD0K1)*dt);
end

W = WL(end);
betaf = W/WTO;

end

