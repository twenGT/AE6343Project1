function [ betaf, W, TSL2WTO, leg ] = accelClimb( betai, WTO, S, Vi, Vf, hi, hf, mode, type )

global g

global TSL_Mil
global TSL_Max
global WTO2S
global VCruise

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
    [~, ~, rho, a] = atmData(hAC(i));
    MAC = VAC(i)/a;
    CL = liftCoeff(WAC(i), S, hAC(i), VAC(i), 1);
    [CD, K1, CD0] = dragCoeff(CL, MAC, type);
    [T, alpha] = thrust(MAC, TSL, hAC(i), 1);
    u = CD/CL*WAC(i)/T;
    WAC(i+1) = WAC(i)*exp(-TSFC(MAC, hAC(i), mode, type)/VAC(i)*...
        ((hAC(i+1) - hAC(i)) + (VAC(i+1)^2 - VAC(i)^2)/(2*g))/(1 - u));
end

W = WAC(end);
betaf = W/WTO;

%Accelerating Climb Constraint

dh = hf - hi;
dV = Vf - Vi;

Z = 1 + sqrt(1 + 3/((CL/CD)^2*(T/W)^2));

RC = sqrt((W/S)*Z/(3*rho*CD0))*(T/W)^(3/2)*(1 - Z/6 - 3/(2*(T/W)^2*(CL/CD)^2*Z));

dt = dh/RC; % Max climb rate (ft/s)



[~, ~, rho, ~] = atmData((hi + hf)/2);
q = .5*rho*(Vf^2 + Vi^2)/2;

TSL2WTO = (betaf/alpha)*((K1*(betaf/q))*(WTO2S) + CD0./((betaf/q)*WTO2S) + 1/VCruise*(dh/dt + (1/(2*g)*dV^2/dt)));

leg = 'Accel. Climb';

end

