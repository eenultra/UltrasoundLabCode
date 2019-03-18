%**************************************************************************
% Spectrum Matlab Library Package               (c) Spectrum GmbH, 2018
%**************************************************************************
% Supplies different common functions for Matlab programs accessing the 
% SpcM driver interface. Feel free to use this source for own projects and
% modify it in any kind
%**************************************************************************
% spcMSetupTrigSoftware:
% software trigger
%**************************************************************************

function [success, cardInfo] = spcMSetupTrigSoftware (cardInfo, trigOut)
    
	global mRegs;
    if (isempty (mRegs))
        mRegs = spcMCreateRegMap ();
    end
	
    if (trigOut ~= 0) & (trigOut ~= 1)
        sprintf (cardInfo.errorText, 'spcMSetupTrigSoftware: trigOut must be 0 (disable) or 1 (enable)');
        success = false;
        return;
    end

    error = 0;
    
    % ----- setup the trigger mode -----
    error = error + spcm_dwSetParam_i32 (cardInfo.hDrv, mRegs('SPC_TRIG_ORMASK'), mRegs('SPC_TMASK_SOFTWARE'));
    error = error + spcm_dwSetParam_i32 (cardInfo.hDrv, mRegs('SPC_TRIG_ANDMASK'),     0);
    error = error + spcm_dwSetParam_i32 (cardInfo.hDrv, mRegs('SPC_TRIG_CH_ORMASK0'),  0);
    error = error + spcm_dwSetParam_i32 (cardInfo.hDrv, mRegs('SPC_TRIG_CH_ORMASK1'),  0);
    error = error + spcm_dwSetParam_i32 (cardInfo.hDrv, mRegs('SPC_TRIG_CH_ANDMASK0'), 0);
    error = error + spcm_dwSetParam_i32 (cardInfo.hDrv, mRegs('SPC_TRIG_CH_ANDMASK1'), 0);
    error = error + spcm_dwSetParam_i32 (cardInfo.hDrv, mRegs('SPC_TRIGGEROUT'), trigOut);
   
    [success, cardInfo] = spcMCheckSetError (error, cardInfo);    
    
    
    
    

    




