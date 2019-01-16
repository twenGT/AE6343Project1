function [ betaf, leg ] = accelClimbMA( betai, TSL2WTO, WTO2S, Vi, Vf, hi, hf, mode, type )

global g

n = 10;
VAC = linspace(Vi, Vf, n);
hAC = linspace(hi, hf, n);
betaLeg = zeros(1,n);
betaLeg(1) = betai;

for i = 1:n-1
    [~, ~, ~, a] = atmData(hAC(i));
    MAC = VAC(i)/a;
    CL = liftCoeff(betaLeg(i)*WTO2S, 1, hAC(i), VAC(i), 1);
    [CD, ~, ~] = dragCoeff(CL, MAC, type);
    SFC = TSFC(MAC, hAC(i), mode, type);
    [~, alpha] = thrust(MAC, 0, hAC(i), 2);
    u = (CD/CL)*(betaLeg(i)/alpha)/TSL2WTO;
    betaLeg(i+1) = betaLeg(i)*exp(-SFC/VAC(i)*...
        ((hAC(i+1) - hAC(i)) + (VAC(i+1)^2 - VAC(i)^2)/(2*g))/(1 - u));
end

betaf = betaLeg(end);

leg = 'Accel. Climb';

end