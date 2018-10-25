function [ TSL2WTO, WTO2SLD ] = F86LCA( beta )

%|2|Take off acceleration|3|Acclerating climb|4|Cruise climb
%|5|Loiter|6|Cruise climb|7|Combat|8|Cruise|9|Loiter
%|10|Landing|11|Max speed at SL|12|

global VCruise
global VMaxSL
global VCombat
global CL_noHL
global h3
global h4
global h6
global h8
global h9
global Rcombat
global nCombat
global type

totalConstraints = numel(beta)-2;

TSL2WTO = cell(totalConstraints-1,2);

%2. Take off
i = 1;
[ ~, TSL2WTO{i,1}, TSL2WTO{i,2} ] = takeOffCA( beta(i+2) );

%3. Accelerating climb
i = i + 1;
[ TSL2WTO{i,1}, TSL2WTO{i,2} ] = accelClimbCA( beta(i+2), 50, h3, 250, VCruise, type );

%4. Cruise climb
i = i + 1;
[ TSL2WTO{i,1}, TSL2WTO{i,2} ] = cruiseClimbCA( beta(i+2), h3, h4, Rcombat, type );

%5. Loiter
i = i + 1;
[ TSL2WTO{i,1}, TSL2WTO{i,2} ] = loiterCA( beta(i+2), h4, VCruise, type );

%6. Cruise climb
i = i + 1;
[ TSL2WTO{i,1}, TSL2WTO{i,2} ] = cruiseClimbCA( beta(i+2), h4, h6, Rcombat, type );

%7. Combat
i = i + 1;
[ TSL2WTO{i,1}, TSL2WTO{i,2} ] = combatCA( beta(i+2), h6, VCombat, nCombat, type );

%8. Cruise
i = i + 1;
[ TSL2WTO{i,1}, TSL2WTO{i,2} ] = cruiseCA( beta(i+2), h8, VCruise, type );

%9. Loiter
i = i + 1;
[ TSL2WTO{i,1}, TSL2WTO{i,2} ] = loiterCA( beta(i+2), h9, VCruise, type );

%10. Landing
WTO2SLD = landingConstraint(beta(i+2), CL_noHL);

%11. Max speed at sea level
i = i + 1;
[ TSL2WTO{i,1}, TSL2WTO{i,2} ] = maxSpeedCA( beta(i+2), 200, VMaxSL, type );

end