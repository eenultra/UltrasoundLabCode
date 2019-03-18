%**************************************************************************
% Spectrum Matlab Library Package               (c) Spectrum GmbH, 2018
%**************************************************************************
% Supplies different common functions for Matlab programs accessing the 
% SpcM driver interface. Feel free to use this source for own projects and
% modify it in any kind
%**************************************************************************
% spcMSetupModeRecStdGate:
% record standard mode gated sampling
%**************************************************************************

function [success, cardInfo] = spcMSetupModeRecStdGate (cardInfo, chEnableH, chEnableL, memSamples, preSamples, postSamples)

	global mRegs;
    if (isempty (mRegs))
        mRegs = spcMCreateRegMap ();
    end

    error = 0;

    % ----- setup the mode -----
    error = error + spcm_dwSetParam_i32 (cardInfo.hDrv, mRegs('SPC_CARDMODE'), mRegs('SPC_REC_STD_GATE'));
    error = error + spcm_dwSetParam_i64m (cardInfo.hDrv, mRegs('SPC_CHENABLE'), chEnableH, chEnableL);
    error = error + spcm_dwSetParam_i64 (cardInfo.hDrv, mRegs('SPC_MEMSIZE'), memSamples);
    error = error + spcm_dwSetParam_i64 (cardInfo.hDrv, mRegs('SPC_PRETRIGGER'), preSamples);
    error = error + spcm_dwSetParam_i64 (cardInfo.hDrv, mRegs('SPC_POSTTRIGGER'), postSamples);
    
    % ----- store some information in the structure -----
    cardInfo.setMemsize      = memSamples;
    cardInfo.setChEnableHMap = chEnableH;
    cardInfo.setChEnableLMap = chEnableL;
    
    [errorCode, cardInfo.setChannels] = spcm_dwGetParam_i32 (cardInfo.hDrv, mRegs('SPC_CHCOUNT'));
    error = error + errorCode;
    
    [success, cardInfo] = spcMCheckSetError (error, cardInfo);
    
    
    


    
    
        