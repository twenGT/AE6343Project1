function [ range ] = rangeAPTA( WTO, TSL2WTO, WTO2S, betaFinal )

global rho_ref
global CL_Max
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

[~, K1, CD0] = dragCoeff(0, 0.6, type);
CD = 4/3*CD0;
CL = sqrt(CD0/(3*K1));

i = i + 1;
h3a = BCA(beta(i), WTO2S);
[~, ~, rho3a, ~] = atmData(h3a);
V3a = sqrt(2/rho3a*WTO2S*sqrt(3*K1/CD0));
[ betatemp, ~ ] = accelClimbMA( beta(i), TSL2WTO, WTO2S, VTO, V3a, 50, h3a, 2, type );


h3b = BCA(betatemp, WTO2S);
[~, ~, rho3b, a3b] = atmData(h3b);
V3b = sqrt(2/rho3b*WTO2S*sqrt(3*K1/CD0));
[ beta(i+1), ~ ] = cruiseClimbMA( betatemp, TSL2WTO, WTO2S, V3b, h3a, h3b, type );

%4. Max range cruise

h4 = h3b;
rho4 = rho3b;
V4 = V3b;
a4 = a3b;
M4 = V4/a4;
Wini = beta(end)*WTO;
Wend = betaFinal*WTO;
S = WTO/WTO2S;
range = 2/TSFC(M4, h4, 3, 2)*sqrt(2/(rho4*S))*sqrt(CL)/CD*(sqrt(Wini)-sqrt(Wend))/6076.12;

end

