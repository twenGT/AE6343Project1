function [ WTOnew ] = WTOCalc( WE2WTO, WF2WTO, WTO )

global WC
global WP

WTOnew = (WC + WP + WF2WTO*WTO*0.1)/(1 - WE2WTO - WF2WTO);

end