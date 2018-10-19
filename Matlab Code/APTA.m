function [ WFinal, beta ] = missionAnalysisAPTA( WTO, S )
%|1|Pre-takeoff|2|Takeoff acceleration|3|Acclerating climb|4|Cruise
%|5|Rendezvous|6|Refueling Sim|7|Accelerating climb|8|Cruise|9|Descend
%|10|Combat training|11|Cruise climb|12|Cruise|13|Landing|14|Reserve

%Assumes future drag polar, BCM = 0.8;

global BCM
global WpreTakeOff

beta = zeros(1,15);
W = zeros(1,15);

%type = 2 for APTA;
type = 2;

i = 1;
W(i) = WTO;
beta(i) = 1;

%1.Pre-takeoff
W(i+1) = W(i) - WpreTakeOff;
beta(i+1) = W(i+1)/W(i);

%2.Takeoff acceleration and rotation, kTO = 1.2

i = i + 1;
[beta(i+1), W(i+1), VTO] = takeOff(beta(i), WTO, S, type);

%3.Acclerating climb
%Assumes the 50ft obstacle is cleared at the end of take-off

h3a = BCA(beta(3), WTO, S);
[~, ~, ~, a3] = atmData(h3a);
V3a = BCM*a3;

[betatemp, ~] = accelClimb(beta(i), WTO, S, VTO, V3a, 50, h3a, 2, type);

%BCA has changed due to new beta. Perform one cruise climb correction

h3b = BCA(betatemp, WTO, S);
i = i + 1;
[beta(i+1), W(i+1)] = cruiseClimb(betatemp, WTO, S, h3a, h3b, type);


%4.Cruise
%At BCM/BCA for 150nm
h4 = h3b;
[~, ~, ~, a4] = atmData(h3b);
V4 = BCM*a4;
i = i + 1;
[beta(i+1), W(i+1)] = BCMCruise(beta(i), WTO, S, V4, h4, 150, type);

%5.Rendezvous
%20000ft and 300knots for 100nm
h5 = 20000;
V5 = 300*1.688;
i = i + 1;
[beta(i+1), W(i+1)] = cruise(beta(i), WTO, S, h5, 100, V5, type);

%6.Refueling simulation
%20000ft and 250knots for 20 min
h6 = 20000;
V6 = 250*1.688;
i = i + 1;
[beta(i+1), W(i+1)] = cruise(beta(i), WTO, S, h6, 250*20/60, V6, type);

%7.Acclerating climb
%Climbs to BCA at BCM

h7 = BCA(beta(7), WTO, S);
[~, ~, ~, a7] = atmData(h7);
V7 = BCM*a7;

i = i + 1;
[beta(i+1), W(i+1)] = accelClimb(beta(i), WTO, S, V6, V7, h6, h7, 2, type);

%8.Cruise
%At BCM/BCA for 100nm

V8 = V7;
h8 = h7;
i = i + 1;
[beta(i+1), W(i+1)] = BCMCruise(beta(i), WTO, S, V8, h8, 100, type);

%9.Descend
%Decending consumes approximately no fuel

i = i + 1;
W(i+1) = W(i);
beta(i+1) = beta(i);

%10.Combat training
%Load factor = 8 for 20min at 15000ft

h10 = 15000;
[~, ~, ~, a10] = atmData(h10);
V10 = BCM*a10;
i = i + 1;
[beta(i+1), W(i+1)] = combat(beta(i), WTO, S, h10, V10, 20, 8, type);

%11.Acclerating climb
%Climbs to BCA at BCM

h11 = BCA(beta(11), WTO, S);
[~, ~, ~, a11] = atmData(h11);
V11 = BCM*a11;

i = i + 1;
[beta(i+1), W(i+1)] = accelClimb(beta(i), WTO, S, V10, V11, h10, h11, 2, type);

%12.Cruise
%At BCM/BCA for 150nm

h12 = h11;
[~, ~, ~, a12] = atmData(h12);
V12 = BCM*a12;

i = i + 1;
[beta(i+1), W(i+1)] = BCMCruise(beta(i), WTO, S, V12, h12, 150, type);

%13.Landing
%Landing consumes approximately no fuel

i = i + 1;
W(i+1) = W(i);
beta(i+1) = beta(i);

%14.Reserve
%At BCM/BCA for 30min at 10000ft

h14 = 10000;
[~, ~, ~, a14] = atmData(h14);
V14 = BCM*a14;
R14 = V14/1.688*30/60;

i = i + 1;
[beta(i+1), W(i+1)] = BCMCruise(beta(i), WTO, S, V14, h14, R14, type);

WFinal = W(end);

end

