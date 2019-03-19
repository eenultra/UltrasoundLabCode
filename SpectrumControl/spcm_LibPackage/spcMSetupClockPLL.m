%**************************************************************************
% Spectrum Matlab Library Package               (c) Spectrum GmbH, 2018
%**************************************************************************
% Supplies different common functions for Matlab programs accessing the 
% SpcM driver interface. Feel free to use this source for own projects and
% modify it in any kind
%**************************************************************************
% spcMSetupClockPLL:
% internal clock using PLL
%**************************************************************************

function [success, cardInfo] = spcMSetupClockPLL (cardInfo, samplerate, clockOut)

	global mRegs;
    if (isempty (mRegs))
        mRegs = spcMCreateRegMap ();
    end

    if (clockOut ~= 0) & (clockOut ~= 1)
        sprintf (cardInfo.errorText, 'spcMSetupClockPLL: clockOut must be 0 (disable) or 1 (enable)');
        success = false;
        return;
    end
    
    % ----- check for clock borders -----
    if (samplerate < cardInfo.minSamplerate)
        samplerate = cardInfo.minSamplerate;
    end
    if (samplerate > cardInfo.maxSamplerate)
        samplerate = cardInfo.maxSamplerate;
    end

    error = 0;

    % ----- setup the clock mode -----
    error = error + spcm_dwSetParam_i32 (cardInfo.hDrv, mRegs('SPC_CLOCKMODE'), mRegs('SPC_CM_INTPLL'));
    error = error + spcm_dwSetParam_i64 (cardInfo.hDrv, mRegs('SPC_SAMPLERATE'), samplerate);
    error = error + spcm_dwSetParam_i32 (cardInfo.hDrv, mRegs('SPC_CLOCKOUT'), clockOut);
    
    [errorCode, cardInfo.setSamplerate] = spcm_dwGetParam_i64 (cardInfo.hDrv, mRegs('SPC_SAMPLERATE'));
    error = error + errorCode;
        
    [errorCode, cardInfo.oversampling]  = spcm_dwGetParam_i32 (cardInfo.hDrv, mRegs('SPC_OVERSAMPLINGFACTOR'));
    error = error + errorCode;
    
    [success, cardInfo] = spcMCheckSetError (error, cardInfo);



    



