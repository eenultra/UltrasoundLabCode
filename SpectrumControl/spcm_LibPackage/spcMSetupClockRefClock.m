%**************************************************************************
% Spectrum Matlab Library Package               (c) Spectrum GmbH, 2018
%**************************************************************************
% Supplies different common functions for Matlab programs accessing the 
% SpcM driver interface. Feel free to use this source for own projects and
% modify it in any kind
%**************************************************************************
% spcMSetupClockRefClock:
% reference clock
%**************************************************************************

function [success, cardInfo] = spcMSetupClockRefClock (cardInfo, refClock, samplerate, clockTerm)

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
    error = error + spcm_dwSetParam_i32 (cardInfo.hDrv, mRegs('SPC_CLOCKMODE'), mRegs('SPC_CM_EXTREFCLOCK'));
    error = error + spcm_dwSetParam_i32 (cardInfo.hDrv, mRegs('SPC_REFERENCECLOCK'), refClock);
    error = error + spcm_dwSetParam_i32 (cardInfo.hDrv, mRegs('SPC_SAMPLERATE'), samplerate);
    error = error + spcm_dwSetParam_i32 (cardInfo.hDrv, mRegs('SPC_CLOCK50OHM'), clockTerm);
    
    [errorCode, cardInfo.setSamplerate] = spcm_dwGetParam_i32 (cardInfo.hDrv, mRegs('SPC_SAMPLERATE'));
    error = error + errorCode;
        
    [errorCode, cardInfo.oversampling]  = spcm_dwGetParam_i32 (cardInfo.hDrv, mRegs('SPC_OVERSAMPLINGFACTOR'));
    error = error + errorCode;
    
    [success, cardInfo] = spcMCheckSetError (error, cardInfo);







   




