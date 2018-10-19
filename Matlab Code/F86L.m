function [WFinal, beta, TSL2WTO, WTO2SLD] = F86L(WTO, S, plotOn)
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
global CL_noHL
global WTO2S

totalLeg = 10;

combatR = 450;

beta = zeros(1,totalLeg);
W = zeros(1,totalLeg);
TSL2WTO = cell(totalLeg,2);

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
[beta(i+1), W(i+1), VTO, TSL2WTO{i,1}, TSL2WTO{i,2}] = takeOff(beta(i), WTO, S, type);

%3.Acclerating climb
%Assumes the 50ft obstacle is cleared at the end of take-off
%Climbs at military power

i = i + 1;
[beta(i+1), W(i+1), TSL2WTO{i,1}, TSL2WTO{i,2}] = accelClimb(beta(i), WTO, S, VTO, VCruise, 50, h3, 2, type);

%4.Cruise climb
%for 550 nm at h4

i = i + 1;
[betatemp, ~, TSL2WTO{i,1}, TSL2WTO{i,2}] = cruiseClimb(beta(i), WTO, S, h3, h4, combatR, type);
[beta(i+1), W(i+1), ~, ~] = cruise(betatemp, WTO, S, h4, combatR, VCruise, type);

%5.Loiter
%for 10 min at h4

i = i + 1;
[beta(i+1), W(i+1), TSL2WTO{i,1}, TSL2WTO{i,2}] = loiter(beta(i), WTO, S, h4, 10, type);

%6.Acclerating climb
%Climbs at max power

i = i + 1;
[beta(i+1), W(i+1), TSL2WTO{i,1}, TSL2WTO{i,2}] = accelClimb(beta(i), WTO, S, VCruise, VCombat, h4, h6, 2, type);

%7.Combat
%for 5 min, at h6 and VCombat, load factor = 1

i = i + 1;
[beta(i+1), W(i+1), TSL2WTO{i,1}, TSL2WTO{i,2}] = combat(beta(i), WTO, S, h6, VCombat, 5, 1, type);

%8.Cruise
%for 550 nm at h8

i = i + 1;
[beta(i+1), W(i+1), TSL2WTO{i,1}, TSL2WTO{i,2}] = cruise(beta(i), WTO, S, h8, combatR, VCruise, type);

%9.Loiter
%for 10 min at h9

i = i + 1;
[beta(i+1), W(i+1), TSL2WTO{i,1}, TSL2WTO{i,2}] = loiter(beta(i), WTO, S, h9, 10, type);

%10.Landing
%MATTINGLY, descent and landing require minimal fuel,
%beta stays the same

WTO2SLD = landingConstraint(beta(i+1), CL_noHL);

WFinal = W(end);

% plot

%     if abs(deltaWF) < 0.1
%         plotOn = 1;
%     else
%         plotOn = 0;
%     end

if plotOn == 1
    figure
    for i = 2:totalLeg-1
        plot(WTO2S,TSL2WTO{i,1},'lineWidth',2);
        hold on
        graphLegend{i-1} = [num2str(i), '. ', TSL2WTO{i,2}];
    end
    line([WTO2SLD, WTO2SLD],[0, 2],'lineWidth',2);
    plot(18500/313.4,7650/18500, 'ro');
    
    graphLegend{i} = [num2str(i+1), '. ', 'Landing'];
    
    legend(graphLegend);
    
    grid on;
    xlabel('W_{TO}/S');
    ylabel('T_{SL}/W_{TO}');
    axis([0 140 0 1.5]);
end

end


