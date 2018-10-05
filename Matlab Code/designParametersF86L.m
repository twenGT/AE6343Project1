function [ ] = designParametersF86L( ~ )
%Design parameters for F86L

global rho_ref

% global AR
% global e

global WC
global WP
global WpreTakeOff

global TSL_Max
global TSL_Mil
global TSL_Nml

global CL_MaxTO
global CL_MaxLD

global C_cruise
global C_loiter
global C_milSubsonic
global C_milSupersonic
global C_maxPower

rho_ref = 0.002377; %slugs/ft^3

%F-86L Data
AR = 4.6;
taper_ratio = 0.6;

%MATTINGLY pg.36
% e = 0.8;

WC = 210;       %lbf
WP = 432;       %lbf
WpreTakeOff = 0;

TSL_Max = 7650; %lbf
TSL_Mil = 5550; %lbf
TSL_Nml = 5100; %lbf

%SLIDES, Single slot
CL_MaxTO = 1.6;
CL_MaxLD = 2;


C_cruise        = 0.9 /3600;
C_loiter        = 0.8 /3600;
C_milSubsonic   = 1.35/3600;
C_milSupersonic = 1.45/3600;
C_maxPower      = 2   /3600;



end