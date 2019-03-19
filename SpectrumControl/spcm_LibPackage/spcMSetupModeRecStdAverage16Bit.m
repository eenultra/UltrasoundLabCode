%**************************************************************************
% Spectrum Matlab Library Package             (c) Spectrum GmbH, 2018
%**************************************************************************
% Supplies different common functions for Matlab programs accessing the 
% SpcM driver interface. Feel free to use this source for own projects and
% modify it in any kind
%**************************************************************************
% spcMSetupModeRecStdAverage:
% record standard mode Average
%**************************************************************************

function [success, cardInfo] = spcMSetupModeRecStdAverage16Bit (cardInfo, chEnableH, chEnableL, memSize, segmentSize, posttrigger, averages)
    
	global mRegs;
    if (isempty (mRegs))
        mRegs = spcMCreateRegMap ();
    end
	
    error = 0;

    % ----- setup the mode -----
    error = error + spcm_dwSetParam_i32 (cardInfo.hDrv, mRegs('SPC_CARDMODE'), mRegs('SPC_REC_STD_AVERAGE_16BIT'));
    error = error + spcm_dwSetParam_i64m (cardInfo.hDrv, mRegs('SPC_CHENABLE'), chEnableH, chEnableL);
    error = error + spcm_dwSetParam_i64 (cardInfo.hDrv, mRegs('SPC_MEMSIZE'), memSize);
    error = error + spcm_dwSetParam_i64 (cardInfo.hDrv, mRegs('SPC_SEGMENTSIZE'), segmentSize);
    error = error + spcm_dwSetParam_i64 (cardInfo.hDrv, mRegs('SPC_POSTTRIGGER'), posttrigger);
    error = error + spcm_dwSetParam_i64 (cardInfo.hDrv, mRegs('SPC_AVERAGES'), averages);
    
    % ----- store some information in the structure -----
    cardInfo.setMemsize      = memSize;
    cardInfo.setChEnableHMap = chEnableH;
    cardInfo.setChEnableLMap = chEnableL;

    [errorCode, cardInfo.setChannels] = spcm_dwGetParam_i32 (cardInfo.hDrv, mRegs('11001 = SPC_CHCOUNT'));
    error = error + errorCode;
    
    [success, cardInfo] = spcMCheckSetError (error, cardInfo);
    
