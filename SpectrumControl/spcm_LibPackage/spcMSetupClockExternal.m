%**************************************************************************
% Spectrum Matlab Library Package               (c) Spectrum GmbH, 2018
%**************************************************************************
% Supplies different common functions for Matlab programs accessing the 
% SpcM driver interface. Feel free to use this source for own projects and
% modify it in any kind
%**************************************************************************
% spcMSetupClockExternal:
% external clock
%**************************************************************************

function [success, cardInfo] = spcMSetupClockExternal (cardInfo, extRange, clockTerm, divider)

	global mRegs;
    if (isempty (mRegs))
        mRegs = spcMCreateRegMap ();
    end

    if (clockTerm ~= 0) & (clockTerm ~= 1)
        sprintf (cardInfo.errorText, 'spcMSetupClockExternal: clockTerm must be 0 (disable) or 1 (enable)');
        success = false;
        return;
    end

    error = 0;

    % ----- setup the clock mode -----
    error = error + spcm_dwSetParam_i32 (cardInfo.hDrv, mRegs('SPC_CLOCKMODE'), mRegs('SPC_CM_EXTERNAL'));
    error = error + spcm_dwSetParam_i32 (cardInfo.hDrv, mRegs('SPC_EXTERNRANGE'), extRange);
    error = error + spcm_dwSetParam_i32 (cardInfo.hDrv, mRegs('SPC_CLOCKDIV'), divider);
    error = error + spcm_dwSetParam_i32 (cardInfo.hDrv, mRegs('SPC_CLOCK50OHM'), clockTerm);
    
    cardInfo.setSamplerate = 1;
    cardInfo.oversampling  = 1;
    
    [success, cardInfo] = spcMCheckSetError (error, cardInfo);



    



