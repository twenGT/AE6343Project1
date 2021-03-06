function [ CD, K1, CD0 ] = dragCoeff(CL, M, type)
%Calculates drag
%Current: type = 1
%Future:  type = 2

%MATTINGLY pg.37 Fig.2.10
%Current
if (type == 1)
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
if (type == 1)
    if M < 0.8
        CD0 = 0.018;
    elseif (0.8 <= M) && (M < 1.2)
        CD0 = 0.055  *M - 0.026;
    else
        CD0 = -0.0025*M + 0.043;
    end
%Future
else    
    if M < 0.8
        CD0 = 0.014;
    elseif (0.8 <= M) && (M < 1.2)
        CD0 = 0.035*M - 0.014;
    else
        CD0 = 0.028;
    end
end

%K2 = -2*Kpp*CL_min
%but assumes K2 = 0

%CD_0 = CD_min + Kpp*CL_min^2
%but assumes CL_min = 0

%CD = K1*CL^2 + K2*CL + CD_0
%but assumes K2 = 0

CD = K1*CL^2 + CD0;

end

