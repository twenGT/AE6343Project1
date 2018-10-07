function [tsfc] = TSFC(M, h, scenario)
%scenario == 1: military
%scenario == 2: maximum (with after-burner)
%scenario == 3: subsonic cruise
%scenario == 4: loiter
%final TSFC is in 1/s

global T_ref
[ T, ~, ~, ~ ] = atmData(h);

if scenario == 1
    tsfc = (1.1 +  0.3*M)*sqrt(T/T_ref);
elseif scenario == 2
    tsfc = (1.5 + 0.23*M)*sqrt(T/T_ref);
elseif scenario == 3
    tsfc = 0.9*sqrt(T/T_ref);
elseif scenario == 4
    tsfc = 0.8*sqrt(T/T_ref);
else
    tsfc = 1;
end

tsfc = tsfc/3600;

end

