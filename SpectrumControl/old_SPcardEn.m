% Single card setup for Spectrum DAQ
%
% July 2014
% James McLaughlan

function SPcardEn

global cardInfo
spcMCloseCard (cardInfo);
clear global cardInfo