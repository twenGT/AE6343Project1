function [tsfc] = TSFC(M, h, mode, type)
%type == 1: F86L
%type == 2: APTA

%mode == 1: military
%mode == 2: maximum (with after-burner)
%mode == 3: subsonic cruise
%mode == 4: loiter
%final TSFC is in 1/s

global T_ref
[ T, ~, ~, ~ ] = atmData(h);

if type == 1
    if mode == 1
        tsfc = (1.01 + 0.3*M)*sqrt(T/T_ref);
        %tsfc = (1.1 +  0.3*M)*sqrt(T/T_ref);
    elseif mode == 2
        tsfc = (2.0 + 0.23*M)*sqrt(T/T_ref);
        %tsfc = (1.5 + 0.23*M)*sqrt(T/T_ref);
    elseif mode == 3
        tsfc = 0.9*sqrt(T/T_ref);
    elseif mode == 4
        tsfc = 0.8*sqrt(T/T_ref);
    else
        tsfc = 1;
    end
elseif type == 2
    if mode == 1
        tsfc = (1.1 +  0.3*M)*sqrt(T/T_ref);
    elseif mode == 2
        tsfc = (1.5 + 0.23*M)*sqrt(T/T_ref);
    elseif mode == 3
        tsfc = 0.9*sqrt(T/T_ref);
    elseif mode == 4
        tsfc = 0.8*sqrt(T/T_ref);
    else
        tsfc = 1;
    end
end

tsfc = tsfc/3600;

end

