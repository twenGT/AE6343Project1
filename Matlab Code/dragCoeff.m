function [ CD ] = dragCoeff( CL, M, ver)
%Calculates drag
%Current: ver = 1
%Future:  ver = 0;

% global AR
% global e

%ANDERSON, pg.109 Eq.2.30
%Kp can be found, but Kpp cannot
%Use K1 directly instead of K1 = Kp + Kpp

% Kp = 1/(pi*e*AR);

%MATTINGLY pg.37 Fig.2.10
%Current
if (ver == 1)
    if M < 0.8
        K1 = 0.14;
    elseif (0.8 <= M) && (M < 1.2)
        K1 = 0.15 *M + 0.02;
    else
        K1 = 0.375*M - 0.25;
    end
%Future
else    
    if M < 1
        K1 = 0.18;
    else
        K1 = 0.18*M;
    end
end

%MATTINGLY pg.37 Fig.2.11
%Current
if (ver == 1)
    if M < 0.8
        CD_0 = 0.018;
    elseif (0.8 <= M) && (M < 1.2)
        CD_0 = 0.055  *M - 0.026;
    else
        CD_0 = -0.0025*M + 0.043;
    end
%Future
else    
    if M < 0.8
        CD_0 = 0.014;
    elseif (0.8 <= M) && (M < 1.2)
        CD_0 = 0.035*M - 0.014;
    else
        CD_0 = 0.028;
    end
end
%K2 = -2*Kpp*CL_min
%but assumes K2 = 0

%CD_0 = CD_min + Kpp*CL_min^2
%but assumes CL_min = 0

%CD = K1*CL^2 + K2*CL + CD_0
%but assumes K2 = 0

CD = K1*CL^2 + CD_0;

end

