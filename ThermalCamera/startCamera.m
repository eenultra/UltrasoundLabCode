% James McLaughlan
% May 2018

clear -except lc ZO QC AG PWM RT IR; 

% initialize the interface as a global variable
global IRInterface;
IRInterface = EvoIRMatlabInterface; 


% check for connection error
if ~IRInterface.connect()                   
    return
end
