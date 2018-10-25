function [ TSL2WTO, leg ] = cruiseClimbCA( beta, hi, hf, range, type )
%Range unit in nautical miles

global VCruise
global WTO2S

dh = hf - hi;
dt = range*6076/VCruise;
hAvg = (2*hf - dh)/2;

[~, ~, rho, a] = atmData((hf + hi)/2);
q = .5*rho*VCruise^2;
M = VCruise/a;

[~, alpha] = thrust(M, 0, hAvg, 1);
[~, K1, CD0] = dragCoeff(0, M, type);

TSL2WTO = (beta/alpha)*((K1*(beta/q))*(WTO2S) + CD0./(beta/q*(WTO2S)) + 1/VCruise*dh/dt);

leg = 'Cruise Climb';

end

