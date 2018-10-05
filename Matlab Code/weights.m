function [ WF_av, WE ] = weights( WTO )
%Calculates fuel weight and empty weight

global WC
global WP

%gamma = WE/WTO
%Empty weight fraction for fighter aircraft
%SLIDES
gamma = 2.34*WTO^(-0.13);
WE = gamma*WTO;

%WTO = WC + WP + WE + WF;
WF_av = WTO - (WC + WP + WE);

end

