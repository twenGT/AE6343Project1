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
beta(1) = 1;
W(1) = WTO;

%1.Pre-takeoff
W(2) = W(1) - WpreTakeOff;
beta(2) = W(2)/W(1);

%2.Takeoff acceleration and rotation

[beta(3), W(3), VTO] = takeOff(beta(2), WTO, S);

%3.Acclerating climb
%Assumes the 50ft obstacle is cleared at the end of take-off
%Military power

[beta(4), W(4)] = accelClimb(beta(3), WTO, S, VTO, VCruise, 50, h3, 1);

%4.Cruise climb

[betatemp, ~] = cruiseClimb(beta(4), WTO, S, h3, h4);
[beta(5), W(5)] = cruise(betatemp, WTO, S, h4, 550);

%5.Loiter
%for 10 min
[beta(6), W(6)] = loiter(beta(5), WTO, S, h4, 10);

%6.Acclerating climb
%Max power

[beta(7), W(7)] = accelClimb(beta(6), WTO, S, VCruise, VCombat, h4, h6, 2);

%7.Combat
%for 5 min

[beta(8), W(8)] = combat(beta(7), WTO, S, h6, VCombat, 5, 1);

%8.Cruise
[beta(9), W(9)] = cruise(beta(8), WTO, S, h8, 550);

%9.Loiter
%for 10 min
[beta(10), W(10)] = loiter(beta(9), WTO, S, h9, 10);

%10.Landing
%MATTINGLY, descent and landing require minimal fuel,
%beta stays the same

WFinal = W(10);

end

