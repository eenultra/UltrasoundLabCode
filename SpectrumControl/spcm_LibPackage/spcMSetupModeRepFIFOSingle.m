%**************************************************************************
% Spectrum Matlab Library Package               (c) Spectrum GmbH, 2018
%**************************************************************************
% Supplies different common functions for Matlab programs accessing the 
% SpcM driver interface. Feel free to use this source for own projects and
% modify it in any kind
%**************************************************************************
% spcMSetupModeRepFIFOSingle:
% replay FIFO mode single
%**************************************************************************

function [success, cardInfo] = spcMSetupModeRepFIFOSingle (cardInfo, chEnableH, chEnableL, blockToRep, loopToRep)
    
	global mRegs;
    if (isempty (mRegs))
        mRegs = spcMCreateRegMap ();
    end
	
    error = 0;
    
    % ----- check for invalid block/loop combinations -----
    if (blockToRep & loopToRep == 0) | (blockToRep == 0 & loopToRep)
        sprintf (cardInfo.errorText, 'spcMSetupModeRepFIFOSingle: Loop and Blocks must be either both zero or both defined to non-zero');
        success = false;
        return;
    end
    
    % ----- segment size can't be zero, we adjust it here -----
    if (blockToRep == 0) & (loopToRep == 0)
        blockToRep = 1024;
    end
    
    % ----- setup the mode -----
    error = error + spcm_dwSetParam_i32 (cardInfo.hDrv, mRegs('SPC_CARDMODE'), mRegs('SPC_REP_FIFO_SINGLE'));
    error = error + spcm_dwSetParam_i64m (cardInfo.hDrv, mRegs('SPC_CHENABLE'), chEnableH, chEnableL);
    error = error + spcm_dwSetParam_i64 (cardInfo.hDrv, mRegs('SPC_SEGMENTSIZE'), blockToRep);
    error = error + spcm_dwSetParam_i64 (cardInfo.hDrv, mRegs('SPC_LOOPS'), loopToRep);
    
    % ----- store some information in the structure -----
    cardInfo.setMemsize      = 0;
    cardInfo.setChEnableHMap = chEnableH;
    cardInfo.setChEnableLMap = chEnableL;
    
    [errorCode, cardInfo.setChannels] = spcm_dwGetParam_i32 (cardInfo.hDrv, mRegs('SPC_CHCOUNT'));
    error = error + errorCode;
    
    [success, cardInfo] = spcMCheckSetError (error, cardInfo);



