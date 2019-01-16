function [ betaf, leg ] = cruiseMA( betai, WTO2S, V, h, range, type )

n = 10;
betaLeg = zeros(1,n+1);
betaLeg(1) = betai;
dt = range*6076.115/V/n;

[~, ~, ~, a] = atmData(h);
MCr = V/a;

for i = 1:n
    CL = liftCoeff(betaLeg(i)*WTO2S, 1, h, V, 1);
    [CD, ~, ~] = dragCoeff(CL, MCr, type);
    betaLeg(i+1) = betaLeg(i)*exp(-TSFC(MCr, h, 3, type)*CD/CL*dt);
end

betaf = betaLeg(end);

leg = 'Cruise';

end
