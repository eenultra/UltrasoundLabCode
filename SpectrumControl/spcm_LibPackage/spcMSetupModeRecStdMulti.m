%**************************************************************************
% Spectrum Matlab Library Package               (c) Spectrum GmbH, 2018
%**************************************************************************
% Supplies different common functions for Matlab programs accessing the 
% SpcM driver interface. Feel free to use this source for own projects and
% modify it in any kind
%**************************************************************************
% spcMSetupModeRecStdMulti:
% record standard mode Multiple Recording
%**************************************************************************

function [success, cardInfo] = spcMSetupModeRecStdMulti (cardInfo, chEnableH, chEnableL, memSamples, segmentSize, postSamples)
    
	global mRegs;
    if (isempty (mRegs))
        mRegs = spcMCreateRegMap ();
    end
	
    error = 0;

    % ----- setup the mode -----
    error = error + spcm_dwSetParam_i32 (cardInfo.hDrv, mRegs('SPC_CARDMODE'), mRegs('SPC_REC_FIFO_SINGLE'));
    error = error + spcm_dwSetParam_i64m (cardInfo.hDrv, mRegs('SPC_CHENABLE'), chEnableH, chEnableL);
    error = error + spcm_dwSetParam_i64 (cardInfo.hDrv, mRegs('SPC_MEMSIZE'), memSamples);
    error = error + spcm_dwSetParam_i64 (cardInfo.hDrv, mRegs('SPC_SEGMENTSIZE'), segmentSize);
    error = error + spcm_dwSetParam_i64 (cardInfo.hDrv, mRegs('SPC_POSTTRIGGER'), postSamples);
    
    % ----- store some information in the structure -----
    cardInfo.setMemsize      = memSamples;
    cardInfo.setChEnableHMap = chEnableH;
    cardInfo.setChEnableLMap = chEnableL;

    [errorCode, cardInfo.setChannels] = spcm_dwGetParam_i32 (cardInfo.hDrv, mRegs('SPC_CHCOUNT'));
    error = error + errorCode;
    
    [success, cardInfo] = spcMCheckSetError (error, cardInfo);
    
