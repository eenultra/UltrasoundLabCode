%**************************************************************************
% Spectrum Matlab Library Package               (c) Spectrum GmbH, 2018
%**************************************************************************
% Supplies different common functions for Matlab programs accessing the 
% SpcM driver interface. Feel free to use this source for own projects and
% modify it in any kind
%**************************************************************************
% spcMSetupTrigChannel:
% channel trigger is set for each channel separately
%**************************************************************************

function [success, cardInfo] = spcMSetupTrigChannel (cardInfo, channel, trigMode, trigLevel0, trigLevel1, pulsewidth, trigOut, singleSrc)
    
	global mRegs;
    if (isempty (mRegs))
        mRegs = spcMCreateRegMap ();
    end
	
    if (channel < 0) | (channel > cardInfo.maxChannels)
        sprintf (cardInfo.errorText, 'spcMSetupTrigChannel: channel number %d not valid. Channels range from 0 to %d\n', channel, cardInfo.maxChannels);
        success = false;
        return;
    end
    
    if (trigOut ~= 0) & (trigOut ~= 1)
        sprintf (cardInfo.errorText, 'spcMSetupTrigChannel: trigOut must be 0 (disable) or 1 (enable)');
        success = false;
        return;
    end
    
    if (singleSrc ~= 0) & (singleSrc ~= 1)
        sprintf (cardInfo.errorText, 'spcMSetupTrigChannel: singleSrc must be 0 (disable) or 1 (enable)');
        success = false;
        return;
    end
    
    error = 0;
    
    % ----- setup the trigger mode -----
    error = error + spcm_dwSetParam_i32 (cardInfo.hDrv, mRegs('SPC_TRIG_CH0_MODE') + channel, trigMode);
    error = error + spcm_dwSetParam_i32 (cardInfo.hDrv, mRegs('SPC_TRIG_CH0_PULSEWIDTH') + channel, pulsewidth);
    error = error + spcm_dwSetParam_i32 (cardInfo.hDrv, mRegs('SPC_TRIG_CH0_LEVEL0') + channel, trigLevel0);
    error = error + spcm_dwSetParam_i32 (cardInfo.hDrv, mRegs('SPC_TRIG_CH0_LEVEL1') + channel, trigLevel1);
    
    error = error + spcm_dwSetParam_i32 (cardInfo.hDrv, mRegs('SPC_TRIG_OUTPUT'), trigOut);
    error = error + spcm_dwSetParam_i32 (cardInfo.hDrv, mRegs('SPC_TRIG_TERM'), 0);
    
    % ----- on singleSrc flag no other trigger source is used -----
    if singleSrc == 1
        error = error + spcm_dwSetParam_i32 (cardInfo.hDrv, mRegs('SPC_TRIG_ORMASK'), 0);
        error = error + spcm_dwSetParam_i32 (cardInfo.hDrv, mRegs('SPC_TRIG_ANDMASK'), 0);
        error = error + spcm_dwSetParam_i32 (cardInfo.hDrv, mRegs('SPC_TRIG_CH_ORMASK1'), 0);
        error = error + spcm_dwSetParam_i32 (cardInfo.hDrv, mRegs('SPC_TRIG_CH_ANDMASK1'), 0);
        
        % ----- some cards need the and mask to use on pulsewidth mode -> to be sure we set the AND mask for all pulsewidth cards -----
        if (bitand (trigMode, mRegs('SPC_TM_PW_GREATER')) ~= 0) | (bitand (trigMode, mRegs('SPC_TM_PW_SMALLER')) ~= 0)
            error = error + spcm_dwSetParam_i32 (cardInfo.hDrv, mRegs('SPC_TRIG_CH_ORMASK0'), 0);
            error = error + spcm_dwSetParam_i32 (cardInfo.hDrv, mRegs('SPC_TRIG_CH_ANDMASK0'), bitshift (1, channel));
        else
            error = error + spcm_dwSetParam_i32 (cardInfo.hDrv, mRegs('SPC_TRIG_CH_ORMASK0'), bitshift (1, channel));
            error = error + spcm_dwSetParam_i32 (cardInfo.hDrv, mRegs('SPC_TRIG_CH_ANDMASK0'), 0);
        end
    end
    
    [success, cardInfo] = spcMCheckSetError (error, cardInfo);    
    

    

