function [ betaf, W ] = accelClimb( betai, WTO, S, Vi, Vf, hi, hf, mode, type )

global TSL_Mil
global TSL_Max

global g

n = 10;
VAC = linspace(Vi, Vf, n);
hAC = linspace(hi, hf, n);
WAC = zeros(1,n);
WAC(1) = betai*WTO;

if mode == 1
    TSL = TSL_Mil;
else
    TSL = TSL_Max;
end

for i = 1:n-1
    [~, ~, ~, a] = atmData(hAC(i));
    MAC = VAC(i)/a;
    CL = liftCoeff(WAC(i), S, hAC(i), VAC(i), 1);
    [CD, ~, ~] = dragCoeff(CL, MAC, type);
    T = thrust(MAC, TSL, hAC(i), 1);
    u = CD/CL*WAC(i)/T;
    WAC(i+1) = WAC(i)*exp(-TSFC(MAC, hAC(i), mode, type)/VAC(i)*...
        ((hAC(i+1) - hAC(i)) + (VAC(i+1)^2 - VAC(i)^2)/(2*g))/(1 - u));
end

W = WAC(end);
betaf = W/WTO;

end

