function [ TSL2WTO, WTO2SLD ] = APTACA( beta, WTO2S_OPT )

%|2|Takeoff acceleration|3|Acclerating climb|4|Cruise|5|Rendezvous
%|6|Refueling Sim|7|Accelerating climb|8|Cruise|10|Combat training
%|11|Acclerating climb|12|Cruise|13|Landing|14|Reserve (Loiter)
%|15|Max speed at SL|16|

global MDash;
global BCM
global VCombat
global CL_noHL
global h5
global V5
global h6
global V6
global h8
global h10
global nCombat
global type

totalConstraints = numel(beta)-3;

TSL2WTO = cell(totalConstraints-1,2);

%2. Take off
i = 1;
[ ~, TSL2WTO{i,1}, TSL2WTO{i,2} ] = takeOffCA( beta(i+2) );

%3. Accelerating climb (i = 2)
i = i + 1;
h3a = BCA(beta(i+2), WTO2S_OPT);
[~, ~, ~, a3] = atmData(h3a);
V3a = BCM*a3;
[ TSL2WTO{i,1}, TSL2WTO{i,2} ] = accelClimbCA( beta(i+2), 50, h3a, 250, V3a, type );

%4. Cruise (i = 3)
i = i + 1;
h4 = BCA(beta(i+2), WTO2S_OPT);
[~, ~, ~, a4] = atmData(h4);
V4 = BCM*a4;
[ TSL2WTO{i,1}, TSL2WTO{i,2} ] = cruiseCA( beta(i+2), h4, V4, type );

%5. Rendezvous (i = 4)
i = i + 1;
[ TSL2WTO{i,1}, ~ ] = cruiseCA( beta(i+2), h5, V5, type );
TSL2WTO{i,2} = 'Rendezvous';

%6. Simulated Air Refueling (i = 5)
i = i + 1;
[ TSL2WTO{i,1}, ~ ] = cruiseCA( beta(i+2), h6, V6, type );
TSL2WTO{i,2} = 'Air Refuel Sim.';

%7. Accelerating climb (i = 6)
i = i + 1;
h7 = BCA(beta(i+2), WTO2S_OPT);
[~, ~, ~, a7] = atmData(h7);
V7 = BCM*a7;
[ TSL2WTO{i,1}, TSL2WTO{i,2} ] = accelClimbCA( beta(i+2), h6, h7, V6, V7, type );

%8. Cruise (i = 7)
i = i + 1;
h8 = BCA(beta(i+2), WTO2S_OPT);
[~, ~, ~, a8] = atmData(h8);
V8 = BCM*a8;
[ TSL2WTO{i,1}, TSL2WTO{i,2} ] = cruiseCA( beta(i+2), h8, V8, type );

%9. Descend
%No analysis needed

%10. Combat training (i = 8)
i = i + 1;
[ TSL2WTO{i,1}, TSL2WTO{i,2} ] = combatCA( beta(i+3), h10, VCombat, nCombat, type );

%11. Acclerating climb (i = 9)
i = i + 1;
h11 = BCA(beta(i+3), WTO2S_OPT);
[~, ~, ~, a11] = atmData(h11);
V11 = BCM*a11;
[ TSL2WTO{i,1}, TSL2WTO{i,2} ] = accelClimbCA( beta(i+3), h10, h11, VCombat, V11, type );

%12. Cruise (i = 10)
i = i + 1;
h12 = BCA(beta(i+3), WTO2S_OPT);
[~, ~, ~, a12] = atmData(h12);
V12 = BCM*a12;
[ TSL2WTO{i,1}, TSL2WTO{i,2} ] = cruiseCA( beta(i+3), h12, V12, type );

%13. Landing (i = 11)
WTO2SLD = landingConstraint(beta(i+4), CL_noHL);

%14. Loiter (i = 12)
i = i + 1;
h14 = BCA(beta(i+4), WTO2S_OPT);
[~, ~, ~, a14] = atmData(h14);
V14 = BCM*a14;
[ TSL2WTO{i,1}, TSL2WTO{i,2} ] = loiterCA( beta(i+4), h14, V14, type );

%15. Max speed at sea level (i = 13)
i = i + 1;
h15 = 200;
[~, ~, ~, a15] = atmData(h15);
V15 = MDash*a15;
[ TSL2WTO{i,1}, TSL2WTO{i,2} ] = maxSpeedCA( beta(i+4), 200, V15, type );

end