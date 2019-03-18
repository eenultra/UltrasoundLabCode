%**************************************************************************
% Spectrum Matlab Library Package               (c) Spectrum GmbH, 2018
%**************************************************************************
% Supplies different common functions for Matlab programs accessing the 
% SpcM driver interface. Feel free to use this source for own projects and
% modify it in any kind
%**************************************************************************
% spcMCheckSetError:
% checks for error code and reads out error information
%**************************************************************************

function [success, cardInfo] = spcMCheckSetError (error, cardInfo)

    if error ~= 0
        cardInfo.setError = true;
       [errorCode, errorReg, errorVal, cardInfo.errorText] = spcm_dwGetErrorInfo_i32 (cardInfo.hDrv);
       success = false;
    else
        success = true;
    end
        


