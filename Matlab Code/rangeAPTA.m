function [ range ] = rangeAPTA( WTO, TSL2WTO, WTO2S, betaFinal )

global rho_ref
global CL_Max
global BCM
global WpreTakeOff
global type

i = 1;
beta(i) = 1;

%1.Pre-takeoff
beta(i+1) = 1 - WpreTakeOff/WTO;

%2. Take off acceleration
i = i + 1;
VTO = sqrt((2*1.2^2)/(rho_ref*CL_Max)*WTO2S);
[ beta(i+1), ~, ~ ] = takeOffMA( beta(i), TSL2WTO, WTO2S, type );

%3. Acclerating climb
%Mode = 2 (max power)
i = i + 1;
h3a = BCA(beta(i), WTO2S);
[~, ~, ~, a3a] = atmData(h3a);
V3a = BCM*a3a;
[ betatemp, ~ ] = accelClimbMA( beta(i), TSL2WTO, WTO2S, VTO, V3a, 50, h3a, 2, type );

h3b = BCA(betatemp, WTO2S);
[~, ~, ~, a3b] = atmData(h3b);
V3b = BCM*a3b;
[ beta(i+1), ~ ] = cruiseClimbMA( betatemp, TSL2WTO, WTO2S, V3b, h3a, h3b, type );

%4. Max range cruise
[~, ~, rho, a] = atmData(h3b);
VCruise = BCM*a;
CL = liftCoeff(WTO2S, 1, h3b, VCruise, 1);
[CD, ~, ~] = dragCoeff(CL, BCM, 2);
Wini = beta(end)*WTO;
Wend = betaFinal*WTO;
S = WTO/WTO2S;
range = 2/TSFC(BCM, h3b, 3, 2)*sqrt(2/(rho*S))*sqrt(CL)/CD*(sqrt(Wini)-sqrt(Wend))/6076.12;

end

