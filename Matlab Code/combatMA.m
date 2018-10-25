function [ betaf, leg ] = combatMA( betai, WTO2S, V, h, t, loadFactor, type )
%Duration t in minutes

n = 10;
betaLeg = zeros(1,n+1);
betaLeg(1) = betai;
dt = t*60/n;

[~, ~, ~, a] = atmData(h);
M = V/a;

for i = 1:n
    CL = liftCoeff(betaLeg(i)*WTO2S, 1, h, V, loadFactor);
    [CD, ~, ~] = dragCoeff(CL, M, type);
    betaLeg(i+1) = betaLeg(i)*exp(-TSFC(M, h, 2, type)*CD/CL*dt);
end

betaf = betaLeg(end);

leg = 'Combat';

end