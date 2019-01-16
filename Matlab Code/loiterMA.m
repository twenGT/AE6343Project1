function [ betaf, leg ] = loiterMA( betai, WTO2S, V, h, t, type)

n = 10;
betaLeg = zeros(1,n+1);
betaLeg(1) = betai;
dt = t*60/n;

[~, ~, ~, a] = atmData(h);
M = V/a;

for i = 1:n
    CL = liftCoeff(betaLeg(i)*WTO2S, 1, h, V, 1);
    [~, K1, CD0] = dragCoeff(CL, M, type);
    betaLeg(i+1) = betaLeg(i)*exp(-TSFC(M, h, 4, type)*sqrt(4*CD0*K1)*dt);
end

betaf = betaLeg(end);

leg = 'Loiter';

end

