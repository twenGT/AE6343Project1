function [ CD ] = drag( CL, M )
%Calculates drag

global AR
global e

%ANDERSON pg.117 Fig2.42
%Piece-wise linear fit from figure as an approximation
if M < 0.92
    CD_0 = 0.016;
elseif (0.92 <= M) && (M < 1.04)
    CD_0 = 0.16667*M - 0.13733;
elseif (1.04 <= M) && (M < 1.4)
    CD_0 = 0.01944*M + 0.01578;
else
    CD_0 = 0.043;
end

%ANDERSON, pg.109 Eq2.30
CD_i = (CL^2)/(pi*e*AR);

CD = CD_0 + CD_i;

end
