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
global nCombat
global type
global WpreTakeOff

beta = zeros(1,totalLeg+1);

i = 1;
beta(i) = 1;

%1.Pre-takeoff
beta(i+1) = 1 - WpreTakeOff/WTO;

%2. Take off acceleration
i = i + 1;
[ beta(i+1), VTO, ~ ] = takeOffMA( beta(i), TSL2WTO, WTO2S, type );

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

%4. Cruise
i = i + 1;
h4 = BCA(beta(i), WTO2S);
[~, ~, ~, a4] = atmData(h4);
V4 = BCM*a4;
[ beta(i+1), ~ ] = cruiseMA( beta(i), WTO2S, V4, h4, r4, type );

%5. Rendezvous (cruise)
i = i + 1;
[ beta(i+1), ~ ] = cruiseMA( beta(i), WTO2S, V5, h5, r5, type );

%6. Simulated Air Refueling (cruise)
i = i + 1;
r6 = V6*t6*60/6076.115;
[ beta(i+1), ~ ] = cruiseMA( beta(i), WTO2S, V6, h6, r6, type );

%7. Acclerating climb
%Mode = 2 (max power)
i = i + 1;
h7 = BCA(beta(i), WTO2S);
[~, ~, ~, a7] = atmData(h7);
V7 = BCM*a7;
[ beta(i+1), ~ ] = accelClimbMA( beta(i), TSL2WTO, WTO2S, V6, V7, h6, h7, 2, type );

%8. Cruise
i = i + 1;
V8 = V7;
h8 = h7;
[ beta(i+1), ~ ] = cruiseMA( beta(i), WTO2S, V8, h8, r8, type );

%9. Descend
i = i + 1;
beta(i+1) = beta(i);

%10. Combat training
i = i + 1;
[ beta(i+1), ~ ] = combatMA( beta(i), WTO2S, VCombat, h10, t10, nCombat, type );

%11. Acclerating climb
i = i + 1;
h11 = BCA(beta(i), WTO2S);
[~, ~, ~, a11] = atmData(h11);
V11 = BCM*a11;
[ beta(i+1), ~ ] = accelClimbMA( beta(i), TSL2WTO, WTO2S, VCombat, V11, h10, h11, 2, type );

%12. Cruise
i = i + 1;
V12 = V11;
h12 = h11;
[ beta(i+1), ~ ] = cruiseMA( beta(i), WTO2S, V12, h12, r12, type );

%13. Landing
i = i + 1;
beta(i+1) = beta(i);

%14. Reserve (Loiter)
i = i + 1;
h14 = BCA(beta(i), WTO2S);
[~, ~, ~, a14] = atmData(h14);
V14 = BCM*a14;
[ beta(i+1), ~ ] = loiterMA( beta(i), WTO2S, V14, h14, t14, type);

end

