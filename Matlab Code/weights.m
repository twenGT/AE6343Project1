function [ WF_av, WE2WTO ] = weights( WTO )
%Calculates fuel weight and empty weight

global WC
global WP

%gamma = WE/WTO
%Empty weight fraction for fighter aircraft
%SLIDES
WE2WTO = 2.34*WTO^(-0.13);

WE = WE2WTO*WTO;

%WTO = WC + WP + WE + WF;
WF_av = WTO - (WC + WP + WE);

end

