function [ TSL2WTO, leg ] = accelClimbCA( beta, hi, hf, Vi, Vf, type )
%Accelerating Climb Constraint
%Based on the last 1/10 of the climb

global g
global WTO2S

n = 10;
dh = (hf - hi)/n;
dV = (Vf - Vi)/n;
hAvg = (2*hf - dh)/2;
VAvg = (2*Vf - dV)/2;

RC = 25;
dt = dh/RC;

[~, ~, rho, a] = atmData(hAvg);
q = .5*rho*(Vf^2 + (Vf - dV)^2)/2;
M = VAvg/a;

[~, alpha] = thrust(M, 0, hAvg, 1);
[~, K1, CD0] = dragCoeff(0, M, type);

TSL2WTO = (beta/alpha)*((K1*(beta/q))*(WTO2S) + CD0./((beta/q)*WTO2S) + 1/VAvg*RC + 1/g*dV/dt);

leg = 'Accel. Climb';

end
