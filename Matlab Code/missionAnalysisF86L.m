function [WFinal, beta] = missionAnalysisF86L(WTO, S)
%|1|Pre-takeoff|2|Takeoff acceleration|3|Acclerating climb|4|Cruise climb
%|5|Loiter|6|Cruise climb|7|Combat|8|Cruise|9|Loiter|10|Landing

global VCruise
global VCombat
global WpreTakeOff
global h3
global h4
global h6
global h8
global h9

beta = zeros(1,10);
W = zeros(1,10);

%type = 1 for F86L;
type = 1;

i = 1;
W(i) = WTO;
beta(i) = 1;

%1.Pre-takeoff
W(i+1) = W(i) - WpreTakeOff;
beta(i+1) = W(i+1)/W(i);

%2.Takeoff acceleration and rotation

i = i + 1;
[beta(i+1), W(i+1), VTO] = takeOff(beta(i), WTO, S, type);

%3.Acclerating climb
%Assumes the 50ft obstacle is cleared at the end of take-off
%Climbs at military power

i = i + 1;
[beta(i+1), W(i+1)] = accelClimb(beta(i), WTO, S, VTO, VCruise, 50, h3, 2, type);

%4.Cruise climb
%for 550 nm at h4

i = i + 1;
[betatemp, ~] = cruiseClimb(beta(i), WTO, S, h3, h4, type);
[beta(i+1), W(i+1)] = cruise(betatemp, WTO, S, h4, 550, VCruise, type);

%5.Loiter
%for 10 min at h4

i = i + 1;
[beta(i+1), W(i+1)] = loiter(beta(i), WTO, S, h4, 10, type);

%6.Acclerating climb
%Climbs at max power

i = i + 1;
[beta(i+1), W(i+1)] = accelClimb(beta(i), WTO, S, VCruise, VCombat, h4, h6, 2, type);

%7.Combat
%for 5 min, at h6 and VCombat, load factor = 1

i = i + 1;
[beta(i+1), W(i+1)] = combat(beta(i), WTO, S, h6, VCombat, 5, 1, type);

%8.Cruise
%for 550 nm at h8

i = i + 1;
[beta(i+1), W(i+1)] = cruise(beta(i), WTO, S, h8, 550, VCruise, type);

%9.Loiter
%for 10 min at h9

i = i + 1;
[beta(i+1), W(i+1)] = loiter(beta(i), WTO, S, h9, 10, type);

%10.Landing
%MATTINGLY, descent and landing require minimal fuel,
%beta stays the same

WFinal = W(end);

end

