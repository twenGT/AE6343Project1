function [TSL_WTO] = constraintAnalysisF86L(WTO, S)
%|1|Pre-takeoff|2|Takeoff acceleration|3|Acclerating climb|4|Cruise climb
%|5|Loiter|6|Cruise climb|7|Combat|8|Cruise|9|Loiter|10|Landing

global rho_ref
global g
global CL_Max
global TSL_Max
global TSL_Mil
global a_ref

global VCruise
global VCombat
global WpreTakeOff
global h3
global h4
global h6
global h8

beta = zeros(1,10);
W = zeros(1,10);
beta(1) = 1;
W(1) = WTO;
WTO_S = 10:10:500;

%1.Pre-takeoff
W(2) = W(1) - WpreTakeOff;
beta(2) = W(2)/W(1);

%2.Takeoff acceleration and rotation, kTO = 1.2
VTO = sqrt((2*beta(2)*1.2^2)/(rho_ref*CL_Max)*WTO/S);
%Assumes CD_R - muTO*CL = 0

%Takeoff acceleration
n = 10;
VTA = linspace(0, VTO, n);
WTA = zeros(1,n+1);
WTA(1) = W(2);
qTA = 1/2*rho_ref*VTA.^2;
MTA = VTA/a_ref;

for i = 2:n
    [CD, ~, K1, CD_0] = dragCoeff(CL_Max, MTA(i), 1);
    [T, alpha] = thrust(MTA(i), TSL_Max, 0, 2);
    u = CD*qTA(i)*S/T;
    WTA(i) = WTA(i-1)*exp(-TSFC(MTA(i), 0, 2)/g*(VTA(i)-VTA(i-1))/(1-u));
end

%Takeoff rotation, t_rot = 2s
WTA(end) = WTA(end-1)*(1 - TSFC(MTA(end), 0, 2)*...
    thrust(MTA(end), TSL_Max, 0, 2)/WTA(end-1)*2);

W(3) = WTA(end);
beta(3) = W(3)/W(1);

%Takeoff Constraint
%SG = (beta(3)/(alpha*g)) * (WTO/TSL_Max) *(VTO^2/(2*g)); %ft This needs to be computed correctly
SG = 2000;
TSL_WTO2 = beta(3)^2/alpha*(1.2^2/(SG*rho_ref*g*CL_Max))*(WTO_S);
plot(WTO_S, TSL_WTO2); hold on;

%3.Acclerating climb
%Assumes the 50ft obstacle is cleared at the end of take-off
n = 10;
VAC1 = linspace(VTO, VCruise, n);
hAC1 = linspace(50, h3, n);
WAC1 = zeros(1,n);
WAC1(1) = W(3);

for i = 1:n-1
    [~, ~, ~, a] = atmData(hAC1(i));
    MAC = VAC1(i)/a;
    CL = liftCoeff(WAC1(i), S, hAC1(i), VAC1(i), 1);
    [CD, ~] = dragCoeff(CL, MAC, 1);
    [T, alpha] = thrust(MAC, TSL_Mil, hAC1(i), 1);
    u = CD/CL*WAC1(i)/T;
    WAC1(i+1) = WAC1(i)*exp(-TSFC(MAC, hAC1(i), 1)/VAC1(i)*...
        ((hAC1(i+1) - hAC1(i)) + (VAC1(i+1)^2 - VAC1(i)^2)/(2*g))/(1 - u));
end

W(4) = WAC1(end);
beta(4) = W(4)/W(1);

%Accelerating Climb Constraint




%4.Cruise climb
n = 10;
hCC1 = linspace(h3, h4, n);
WCC1 = zeros(1,n);
WCC1(1) = W(4);

for i = 1:n-1
    [~, ~, ~, a] = atmData(hCC1(i));
    MCC1 = VCruise/a;
    CL = liftCoeff(WCC1(i), S, hCC1(i), VCruise, 1);
    [CD, ~] = dragCoeff(CL, MCC1, 1);
    [T, alpha] = thrust(MCC1, TSL_Mil*1.1, hCC1(i), 1);
    u = CD/CL*WCC1(i)/T;
    WCC1(i+1) = WCC1(i)*exp(-TSFC(MCC1, hCC1(i), 1)/VCruise*(hCC1(i+1) - hCC1(i))/...
        (1 - u));
end

W(5) = WCC1(end);
beta(5) = W(5)/W(1);

%Cruise Climb Constraint
q = .5*rho_ref*VCruise^2;
dh = h4 - h3;
dt = ((550*6076)/(450*1.688)); %550nm -> ft, 450kts -> ft/s
for i = 1:length(WTO_S)
    TSL_WTO4(i) = (beta(4)/alpha) * ((K1*(beta(4)/q)) * (WTO_S(i)) + CD_0/((beta(4)/q) * (WTO_S(i))) + 1/VCruise * dh/dt);
end
plot(WTO_S, TSL_WTO4); hold on;


%5.Loiter
%for 10 min
n = 10;
hL1 = h4;
WL1 = zeros(1,n+1);
WL1(1) = W(5);
dt = 10*60/n;

[~, ~, ~, a] = atmData(hL1);
ML1 = VCruise/a;
[~, CD0K1] = dragCoeff(0, ML1, 1);

for i = 1:n
    WL1(i+1) = WL1(i)*exp(-TSFC(ML1, hL1, 4)*sqrt(4*CD0K1)*dt);
end

W(6) = WL1(end);
beta(6) = W(6)/W(1);

%Loiter Constraint
%Assume loitering radius is great enough to neglect airspeed loss
for i = 1:length(WTO_S)
      TSL_WTO5(i) = (beta(5)/alpha) * ((K1*(beta(5)/q)) * (WTO_S(i)) + CD_0/((beta(5)/q) * (WTO_S(i)))); %Use cruise correct??
end
plot(WTO_S, TSL_WTO5); hold on;


%6.Acclerating climb 
%Assumes military power 
n = 10;
%VAC2 = linspace(VCruise, VCruise, n);
VAC2 = linspace(VCruise, VCombat, n);
hAC2 = linspace(h4, h6, n);
WAC2 = zeros(1,n);
WAC2(1) = W(6);

for i = 1:n-1
    [~, ~, ~, a] = atmData(hAC2(i));
    MAC = VAC2(i)/a;
    CL = liftCoeff(WAC2(i), S, hAC2(i), VAC2(i), 1);
    [CD, ~] = dragCoeff(CL, MAC, 1);
    [T, alpha] = thrust(MAC, TSL_Mil*1.2, hAC2(i), 1);
    u = CD/CL*WAC2(i)/T;
    WAC2(i+1) = WAC2(i)*exp(-TSFC(MAC, hAC2(i), 1)/VAC2(i)*...
        (hAC2(i+1) - hAC2(i))/(1 - u));
%        ((hAC2(i+1) - hAC2(i)) + (VAC2(i+1)^2 - VAC2(i)^2)/(2*g))/(1 - u));
end

W(7) = WAC2(end);
beta(7) = W(7)/W(1);

%Accelerating Climb Constraint
q = .5*rho_ref*VCruise^2;
dh = h6 - h4;
dV = VAC2(end) - VAC2(1);
dt = dh/90; % Max climb rate (seconds)

for i = 1:length(WTO_S)
    TSL_WTO6(i) = (beta(6)/alpha) * ((K1*(beta(6)/q)) * (WTO_S(i)) + ... %Not working correctly values too high***
        CD_0/((beta(6)/q) * (WTO_S(i))) + dh/dt + (1/g * dV/dt) );
end
%plot(WTO_S, TSL_WTO6); hold on;

%7.Combat
%for 5 min
n = 10;
hCb = h6;
WCb = zeros(1,n+1);
WCb(1) = W(7);
dt = 5*60/n;

[~, ~, ~, a] = atmData(hCb);
MCb = VCombat/a;
[CD, ~] = dragCoeff(0, MCb, 1);

for i = 1:n
    CL = liftCoeff(WCb(i), S, hCb, VCombat, 1);
    WCb(i+1) = WCb(i)*exp(-TSFC(MCb, hCb, 2)*CD/CL*dt);
end

W(8) = WCb(end);
beta(8) = W(8)/W(1);

%Combat Constraint
q = .5*rho_ref*VCombat^2;
for i = 1:length(WTO_S)
      TSL_WTO7(i) = (beta(7)/alpha) * ((K1*(beta(7)/q)) * (WTO_S(i)) + CD_0/((beta(7)/q) * (WTO_S(i))));
end
plot(WTO_S, TSL_WTO7); hold on;

%8.Cruise
n = 100;
hCr = h8;
WCr = zeros(1,n+1);
WCr(1) = W(8);
%550 nautical miles
dt = 550*6076.115/VCruise/n;

[~, ~, ~, a] = atmData(hCr);
MCr = VCruise/a;
[CD, ~] = dragCoeff(0, MCr, 1);

for i = 1:n
    CL = liftCoeff(WCr(i), S, hCr, VCruise, 1);
    WCr(i+1) = WCr(i)*exp(-TSFC(MCr, hCr, 3)*CD/CL*dt);
end

W(9) = WCr(end);
beta(9) = W(9)/W(1);

%Cruise Constraint
q = .5*rho_ref*VCruise^2;
for i = 1:length(WTO_S)
      TSL_WTO8(i) = (beta(8)/alpha) * ((K1*(beta(8)/q)) * (WTO_S(i)) + CD_0/((beta(8)/q) * (WTO_S(i))));
end
plot(WTO_S, TSL_WTO8); hold on;

%9.Loiter
%for 10 min
n = 10;
hL2 = h4;
WL2 = zeros(1,n+1);
WL2(1) = W(9);
dt = 10*60/n;

[~, ~, ~, a] = atmData(hL2);
ML2 = VCruise/a;
[~, CD0K1] = dragCoeff(0, ML2, 1);

for i = 1:n
    WL2(i+1) = WL2(i)*exp(-TSFC(ML2, hL2, 4)*sqrt(4*CD0K1)*dt);
end

W(10) = WL2(end);
beta(10) = W(10)/W(1);

%Loiter Constraint
%Assume loitering radius is great enough to neglect airspeed loss
for i = 1:length(WTO_S)
      TSL_WTO9(i) = (beta(9)/alpha) * ((K1*(beta(9)/q)) * (WTO_S(i)) + CD_0/((beta(9)/q) * (WTO_S(i)))); 
end
plot(WTO_S, TSL_WTO9); hold on;


%10.Landing
%MATTINGLY, descent and landing require minimal fuel,
%beta stays the same

VTD = VTO;
tfr = 3; %Touch dowm free roll time set to 3 seconds
Sfr = tfr*VTD; %Touch down free roll distance



%WFinal = W(10);

end