function [ beta ] = APTAMA( TSL2WTO, WTO2S, WTO, totalLeg )
%|0|Initial|1|Pre-takeoff|2|Takeoff acceleration|3|Acclerating climb
%|4|Cruise|5|Rendezvous|6|Refueling Sim|7|Accelerating climb|8|Cruise
%|9|Descend|10|Combat training|11|Accelerating climb|12|Cruise|13|Landing
%|14|Reserve (loiter)|15|

global BCM
global V5
global V6
global VCombat
global r4
global r5
global r8
global r12
global t6
global t10
global t14
global h5
global h6
global h10
global h14
global nCombat
global type
global WpreTakeOff

beta = zeros(1,totalLeg+1);

i = 1;
beta(i) = 1;

%1.Pre-takeoff
beta(i+1) = 1 - WpreTakeOff/WTO;

i = i + 1;
%2. Take off acceleration
[ beta(i+1), VTO, ~ ] = takeOffMA( beta(i), TSL2WTO, WTO2S, type );

i = i + 1;
%3. Acclerating climb
%Mode = 2 (max power)
h3a = BCA(beta(i), WTO2S);
[~, ~, ~, a3a] = atmData(h3a);
V3a = BCM*a3a;
[ betatemp, ~ ] = accelClimbMA( beta(i), TSL2WTO, WTO2S, VTO, V3a, 50, h3a, 2, type );

h3b = BCA(betatemp, WTO2S);
[~, ~, ~, a3b] = atmData(h3b);
V3b = BCM*a3b;
[ beta(i+1), ~ ] = cruiseClimbMA( betatemp, TSL2WTO, WTO2S, V3b, h3a, h3b, type );

i = i + 1;
%4. Cruise
h4 = BCA(beta(i), WTO2S);
[~, ~, ~, a4] = atmData(h4);
V4 = BCM*a4;
[ beta(i+1), ~ ] = cruiseMA( beta(i), WTO2S, V4, h4, r4, type );

i = i + 1;
%5. Rendezvous (cruise)
[ beta(i+1), ~ ] = cruiseMA( beta(i), WTO2S, V5, h5, r5, type );

i = i + 1;
%6. Simulated Air Refueling (cruise)
r6 = V6*t6*60/6076.115;
[ beta(i+1), ~ ] = cruiseMA( beta(i), WTO2S, V6, h6, r6, type );

i = i + 1;
%7. Acclerating climb
%Mode = 2 (max power)
h7 = BCA(beta(i), WTO2S);
[~, ~, ~, a7] = atmData(h7);
V7 = BCM*a7;
[ beta(i+1), ~ ] = accelClimbMA( beta(i), TSL2WTO, WTO2S, V6, V7, h6, h7, 2, type );

i = i + 1;
%8. Cruise
V8 = V7;
h8 = h7;
[ beta(i+1), ~ ] = cruiseMA( beta(i), WTO2S, V8, h8, r8, type );

i = i + 1;
%9. Descend
beta(i+1) = beta(i);

i = i + 1;
%10. Combat training
[ beta(i+1), ~ ] = combatMA( beta(i), WTO2S, VCombat, h10, t10, nCombat, type );

i = i + 1;
%11. Acclerating climb
h11 = BCA(beta(i), WTO2S);
[~, ~, ~, a11] = atmData(h11);
V11 = BCM*a11;
[ beta(i+1), ~ ] = accelClimbMA( beta(i), TSL2WTO, WTO2S, VCombat, V11, h10, h11, 2, type );

i = i + 1;
%12. Cruise
V12 = V11;
h12 = h11;
[ beta(i+1), ~ ] = cruiseMA( beta(i), WTO2S, V12, h12, r12, type );

i = i + 1;
%13. Landing
beta(i+1) = beta(i);

i = i + 1;
%14. Reserve (Maximum Endurance)
[ beta(i+1), ~ ] = maxEnduroMA( beta(i), WTO2S, h14, t14, type );
end