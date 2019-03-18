%**************************************************************************
% Spectrum Matlab Library Package               (c) Spectrum GmbH, 2018
%**************************************************************************
% Supplies different common functions for Matlab programs accessing the 
% SpcM driver interface. Feel free to use this source for own projects and
% modify it in any kind
%**************************************************************************
% spcMSetupModeRecFIFOSingle:
% record FIFO mode single run
%**************************************************************************

function [success, cardInfo] = spcMSetupModeRecFIFOSingle (cardInfo, chEnableH, chEnableL, preSamples, blockToRec, loopToRec)

	global mRegs;
    if (isempty (mRegs))
        mRegs = spcMCreateRegMap ();
    end

    error = 0;

    % ----- check for invalid block/loop combinations -----
    if (blockToRec > 0 & loppToRec == 0) | (blockToRec == 0 & loopToRec > 0)
        sprintf (cardInfo.errorText, 'spcMSetupModeRecFIFOSingle: Loop and Blocks must be either both zero or both defined to non-zero\n');
        success = false;
        return;
    end
    
    % ----- segment size can't be zero, we adjust it here -----
    if blockToRec == 0 & loopToRec == 0
        blockToRec = 1024;
    end
    
    % ----- setup the mode -----
    error = error + spcm_dwSetParam_i32 (cardInfo.hDrv, mRegs('SPC_CARDMODE'), mRegs('SPC_REC_FIFO_SINGLE'));
    error = error + spcm_dwSetParam_i64m (cardInfo.hDrv, mRegs('SPC_CHENABLE'), chEnableH, chEnableL);
    error = error + spcm_dwSetParam_i64 (cardInfo.hDrv, mRegs('SPC_PRETRIGGER'), preSamples);
    error = error + spcm_dwSetParam_i64 (cardInfo.hDrv, mRegs('SPC_SEGMENTSIZE'), blockToRec);
    error = error + spcm_dwSetParam_i64 (cardInfo.hDrv, mRegs('SPC_LOOPS'), loopToRec);
    
    % ----- store some information in the structure -----
    cardInfo.setMemsize      = 0;
    cardInfo.setChEnableHMap = chEnableH;
    cardInfo.setChEnableLMap = chEnableL;
    
    [errorCode, cardInfo.setChannels] = spcm_dwGetParam_i32 (cardInfo.hDrv, mRegs('SPC_CHCOUNT'));
    error = error + errorCode;
    
    [success, cardInfo] = spcMCheckSetError (error, cardInfo);
    
    

    
    
    
    
    



    
    
    



















  
    
