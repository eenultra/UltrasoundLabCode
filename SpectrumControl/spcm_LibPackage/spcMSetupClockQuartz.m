%**************************************************************************
% Spectrum Matlab Library Package               (c) Spectrum GmbH, 2018
%**************************************************************************
% Supplies different common functions for Matlab programs accessing the 
% SpcM driver interface. Feel free to use this source for own projects and
% modify it in any kind
%**************************************************************************
% spcMSetupClockQuartz:
% internal clock using high precision quartz
%**************************************************************************

function [success, cardInfo] = spcMSetupClockQuartz (cardInfo, samplerate, clockOut)

	global mRegs;
    if (isempty (mRegs))
        mRegs = spcMCreateRegMap ();
    end

    error = 0;
    
    % ----- setup the clock mode -----
    error = error + spcm_dwSetParam_i32 (cardInfo.hDrv, mRegs('SPC_CLOCKMODE'), mRegs('SPC_CM_QUARTZ1'));
    error = error + spcm_dwSetParam_i32 (cardInfo.hDrv, mRegs('SPC_SAMPLERATE'), samplerate);
    error = error + spcm_dwSetParam_i32 (cardInfo.hDrv, mRegs('SPC_CLOCKOUT'), clockOut);
    
    [errorCode, cardInfo.setSamplerate] = spcm_dwGetParam_i32 (cardInfo.hDrv, mRegs('SPC_SAMPLERATE'));
    error = error + errorCode;
        
    [errorCode, cardInfo.oversampling]  = spcm_dwGetParam_i32 (cardInfo.hDrv, mRegs('SPC_OVERSAMPLINGFACTOR'));
    error = error + errorCode;
    
    [success, cardInfo] = spcMCheckSetError (error, cardInfo);


