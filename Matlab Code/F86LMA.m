function [ beta ] = F86LMA( TSL2WTO, WTO2S, totalLeg )
%|1|Pre-takeoff|2|Take off acceleration|3|Acclerating climb|4|Cruise climb
%|5|Loiter|6|Cruise climb|7|Combat|8|Cruise|9|Loiter|10|Landing|11|

global VCruise
global VCombat
global h3
global h4
global t5
global h6
global t7
global h8
global h9
global t9
global Rcombat
global nCombat
global type

beta = zeros(1,totalLeg+1);

i = 1;
beta(i) = 1;

%1.Pre-takeoff
beta(i+1) = beta(i);

%2. Take off acceleration
i = i + 1;
[ beta(i+1), VTO, ~ ] = takeOffMA( beta(i), TSL2WTO, WTO2S, type );

%3. Acclerating climb
%Mode = 2 (max power)
i = i + 1;
[ beta(i+1), ~ ] = accelClimbMA( beta(i), TSL2WTO, WTO2S, VTO, VCruise, 50, h3, 2, type );

%4. Cruise climb
i = i + 1;
%Get to altitude
[ betatemp, ~ ] = cruiseClimbMA( beta(i), TSL2WTO, WTO2S, VCruise, h3, h4, type );
%Cruise
[ beta(i+1), ~ ] = cruiseMA( betatemp, WTO2S, VCruise, h4, Rcombat, type );

%5. Loiter
i = i + 1;
[ beta(i+1), ~ ] = loiterMA( beta(i), WTO2S, VCruise, h4, t5, type);

%6. Cruise climb
i = i + 1;
%Get to altitude
[ beta(i+1), ~ ] = cruiseClimbMA( beta(i), TSL2WTO, WTO2S, VCruise, h4, h6, type );

%7. Combat
%Max load factor is 1.4 at 47500 ft.
i = i + 1;
[ beta(i+1), ~ ] = combatMA( beta(i), WTO2S, VCombat, h6, t7, nCombat, type );

%8. Cruise
i = i + 1;
[ beta(i+1), ~ ] = cruiseMA( beta(i), WTO2S, VCruise, h8, Rcombat, type );

%9. Loiter
i = i + 1;
[ beta(i+1), ~ ] = loiterMA( beta(i), WTO2S, VCruise, h9, t9, type);

%10.Landing
i = i + 1;
beta(i+1) = beta(i);

end

