function [ betaf, leg ] = cruiseClimbMA( betai, TSL2WTO, WTO2S, V, hi, hf, type )

n = 10;
hCC = linspace(hi, hf, n);
betaLeg = zeros(1,n);
betaLeg(1) = betai;

for i = 1:n-1
    [~, ~, ~, a] = atmData(hCC(i));
    MCCa = V/a;
    CL = liftCoeff(betaLeg(i)*WTO2S, 1, hCC(i), V, 1);
    [CD, ~, ~] = dragCoeff(CL, MCCa, type);
    [~, alpha] = thrust(MCCa, 0, hCC(i), 1);
    u = (CD/CL)*(betaLeg(i)/alpha)/TSL2WTO;
    betaLeg(i+1) = betaLeg(i)*exp(-TSFC(MCCa, hCC(i), 1, type)/V*...
        (hCC(i+1) - hCC(i))/(1 - u));
end

betaf = betaLeg(end);

leg = 'Cruise Climb';

end

