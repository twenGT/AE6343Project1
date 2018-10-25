function [ ] = CAPlot( TSL2WTO, TSL2WTO_OPT, WTO2S_OPT, WTO2SLD, type )

global WTO2S;

figure

color = [255   0   0;...
         255 130   0;...
         255 216   0;...
         233 255   0;...
         136 255   0;...
           0 255 153;...
           0 255 255;...
           0 170 255;...
           0  70 255;...
         115   0 255;...
         200   0 255;...
         175 175 175;...
          50  50  50];
color = color/300;

colorCount = 1;
if type == 1
    
    %Take off to loiter
    for i = 1:8
        plot(WTO2S,TSL2WTO{i,1},'lineWidth',2,'color',color(colorCount,:));
        hold on
        graphLegend{i} = [num2str(i+1), '. ', TSL2WTO{i,2}];
        colorCount = colorCount + 1;
    end
    %Landing
    i = i + 1;
    line([WTO2SLD, WTO2SLD],[0, 2],'lineWidth',2,'color',color(colorCount,:));
    graphLegend{i} = [num2str(i+1), '. ', 'Landing'];
    colorCount = colorCount + 1;
    %Max speed
    i = i + 1;
    plot(WTO2S,TSL2WTO{i-1,1},'lineWidth',2,'color',color(colorCount,:));
    graphLegend{i} = [num2str(i+1), '. ', TSL2WTO{i-1,2}];
    colorCount = colorCount + 1;
    
elseif type == 2
    
    %Take off to cruise
    for i = 1:7
        plot(WTO2S,TSL2WTO{i,1},'lineWidth',2,'color',color(colorCount,:));
        hold on
        graphLegend{i} = [num2str(i+1), '. ', TSL2WTO{i,2}];
        colorCount = colorCount + 1;
    end
    %Combat training to cruise
    for i = 8:10
        plot(WTO2S,TSL2WTO{i,1},'lineWidth',2,'color',color(colorCount,:));
        hold on
        graphLegend{i} = [num2str(i+2), '. ', TSL2WTO{i,2}];
        colorCount = colorCount + 1;
    end
    %Landing (i = 11)
    i = i + 1;
    line([WTO2SLD, WTO2SLD],[0, 2],'lineWidth',2,'color',color(colorCount,:));
    graphLegend{i} = [num2str(i+2), '. ', 'Landing'];
    colorCount = colorCount + 1;
    %Loiter (i = 12)
    plot(WTO2S,TSL2WTO{i,1},'lineWidth',2,'color',color(colorCount,:));
    i = i + 1;
    graphLegend{i} = [num2str(i+2), '. ', TSL2WTO{i-1,2}];
    colorCount = colorCount + 1;
    %Max speed (i = 13)
    plot(WTO2S,TSL2WTO{i,1},'lineWidth',2,'color',color(colorCount,:));
    i = i + 1;
    graphLegend{i} = [num2str(i+2), '. ', TSL2WTO{i-1,2}];
    
end

i = i + 1;
plot(WTO2S_OPT, TSL2WTO_OPT, 'ro');
graphLegend{i} = 'Design Point';

if type == 1
    %F86L Data
    i = i + 1;
    plot(18500/313.4,7650/18500, 'b*');
    graphLegend{i} = 'F-86L Data';
end

legend(graphLegend);

grid on;
xlabel('W_{TO}/S');
ylabel('T_{SL}/W_{TO}');
axis([20 140 0 1.5]);

end