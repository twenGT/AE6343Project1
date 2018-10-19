function [ betaf, W, TSL2WTO, leg ] = cruiseClimb( betai, WTO, S, hi, hf, range, type )
%Range unit in nautical miles

global VCruise
global TSL_Mil
global WTO2S

%altitude change
n = 10;
hCC = linspace(hi, hf, n);
WCC = zeros(1,n);
WCC(1) = betai*WTO;

for i = 1:n-1
    [~, ~, ~, a] = atmData(hCC(i));
    MCCa = VCruise/a;
    CL = liftCoeff(WCC(i), S, hCC(i), VCruise, 1);
    [CD, K1, CD0] = dragCoeff(CL, MCCa, type);
    [T, alpha] = thrust(MCCa, TSL_Mil*1.1, hCC(i), 1);
    u = CD/CL*WCC(i)/T;
    WCC(i+1) = WCC(i)*exp(-TSFC(MCCa, hCC(i), 1, type)/VCruise*(hCC(i+1) - hCC(i))/...
        (1 - u));
end

W = WCC(end);
betaf = W/WTO;

%Cruise Climb Constraint

dh = hf - hi;
dt = range*6076/VCruise;

[~, ~, rho, ~] = atmData((hf + hi)/2);
q = .5*rho*VCruise^2;

TSL2WTO = (betaf/alpha)*((K1*(betaf/q))*(WTO2S) + CD0./(betaf/q*(WTO2S)) + 1/VCruise*dh/dt);

leg = 'Cruise Climb';

end

