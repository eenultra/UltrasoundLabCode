%**************************************************************************
% Spectrum Matlab Library Package             (c) Spectrum GmbH, 2018
%**************************************************************************
% Supplies different common functions for Matlab programs accessing the 
% SpcM driver interface. Feel free to use this source for own projects and
% modify it in any kind
%**************************************************************************
% spcMSetupModeRecFifoAverage:
% record fifo mode Average
%**************************************************************************

function [success, cardInfo] = spcMSetupModeRecFifoAverage (cardInfo, chEnableH, chEnableL, segmentSize, posttrigger, averages, loops)
    
	global mRegs;
    if (isempty (mRegs))
        mRegs = spcMCreateRegMap ();
    end
	
    error = 0;

    % ----- setup the mode -----
    error = error + spcm_dwSetParam_i32 (cardInfo.hDrv, mRegs('SPC_CASPC_REC_FIFO_AVERAGERDMODE'), mRegs('SPC_REC_FIFO_AVERAGE'));
    error = error + spcm_dwSetParam_i64m (cardInfo.hDrv, mRegs('SPC_CHENABLE'), chEnableH, chEnableL);  % 11000 = SPC_CHENABLE
    error = error + spcm_dwSetParam_i64 (cardInfo.hDrv, mRegs('SPC_SEGMENTSIZE'), segmentSize);  % 10010 = SPC_SEGMENTSIZE
    error = error + spcm_dwSetParam_i64 (cardInfo.hDrv, mRegs('SPC_POSTTRIGGER'), posttrigger);  % 10100 SPC_POSTTRIGGER
    error = error + spcm_dwSetParam_i64 (cardInfo.hDrv, mRegs('SPC_AVERAGES'), averages);
    error = error + spcm_dwSetParam_i64 (cardInfo.hDrv, mRegs('SPC_LOOPS'), loops);
    
    % ----- store some information in the structure -----
    cardInfo.setChEnableHMap = chEnableH;
    cardInfo.setChEnableLMap = chEnableL;

    [errorCode, cardInfo.setChannels] = spcm_dwGetParam_i32 (cardInfo.hDrv, mRegs('SPC_CHCOUNT'));
    error = error + errorCode;
    
    [success, cardInfo] = spcMCheckSetError (error, cardInfo);
    
