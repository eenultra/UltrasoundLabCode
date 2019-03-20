% Disconnects card

% James McLaughlan
% University of Leeds
% March 2019

function daqEnSingleAq

global cardInfo

spcMCloseCard (cardInfo);

cardInfo = [];

disp('Card disconnected');


