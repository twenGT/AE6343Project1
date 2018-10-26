function [ betaf, leg ] = maxEnduroMA( betai, WTO2S, h, t, type )


n = 10;
betaLeg = zeros(1,n+1);
betaLeg(1) = betai;
dt = t*60/n;

[~, ~, rho, a] = atmData(h);
[CD, K1, CD0] = dragCoeff(0, 0.5, type);
CL = sqrt(CD0/K1);

for i = 1:n
    V = sqrt(betaLeg(i)*2/rho*sqrt(K1/CD0)*WTO2S);
    M = V/a;
    betaLeg(i+1) = betaLeg(i)*exp(-TSFC(M, h, 3, type)*CD/CL*dt);
end

betaf = betaLeg(end);

leg = 'MaxEnduro';

end
