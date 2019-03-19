%**************************************************************************
% Spectrum Matlab Library Package               (c) Spectrum GmbH, 2018
%**************************************************************************
% Supplies different common functions for Matlab programs accessing the 
% SpcM driver interface. Feel free to use this source for own projects and
% modify it in any kind
%**************************************************************************
% spcMErrorMessageStdOut:
% prints the error message to std out and ends the driver if it's active
% program can be left with this function
%**************************************************************************

function spcMErrorMessageStdOut (cardInfo, message, printCardErr)
    
    fprintf (message);
    
    if (printCardErr == true)
        fprintf (cardInfo.errorText);
    end
        
    if (cardInfo.hDrv ~= 0)
        spcMCloseCard (cardInfo);
    end
        


