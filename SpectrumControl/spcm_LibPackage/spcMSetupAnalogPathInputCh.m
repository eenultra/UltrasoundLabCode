%**************************************************************************
% Spectrum Matlab Library Package               (c) Spectrum GmbH, 2018
%**************************************************************************
% Supplies different common functions for Matlab programs accessing the 
% SpcM driver interface. Feel free to use this source for own projects and
% modify it in any kind
%**************************************************************************
% spcMSetupAnalogPathInputCh:
% allows all analog input channel related settings (M3i version)
%**************************************************************************

function [success, cardInfo] = spcMSetupAnalogPathInputCh (cardInfo, channel, path, inputRange, term, ACCoupling, BWLimit, diffInput)

	global mRegs;
    if (isempty (mRegs))
        mRegs = spcMCreateRegMap ();
    end

    if (channel < 0) | (channel >= cardInfo.maxChannels)
        sprintf (cardInfo.errorText, 'spcMSetupAnalogPathInputCh: channel number %d not valid. Channels range from 0 to %d\n', channel, cardInfo.maxChannels);
        success = false;
        return;
    end
    
    if (term ~= 0) & (term ~= 1)
        sprintf (cardInfo.errorText, 'spcMSetupAnalogPathInputCh: term must be 0 (disable) or 1 (enable)');
        success = false;
        return;
    end
    
    if (ACCoupling ~= 0) & (ACCoupling ~= 1)
        sprintf (cardInfo.errorText, 'spcMSetupAnalogPathInputCh: ACCoupling must be 0 (DC) or 1 (AC)');
        success = false;
        return;
    end
    
    if (BWLimit ~= 0) & (BWLimit ~= 1)
        sprintf (cardInfo.errorText, 'spcMSetupAnalogPathInputCh: BWLimit must be 0 (full bandwidth) or 1 (BW filter active)');
        success = false;
        return;
    end
    
    if (diffInput ~= 0) & (diffInput ~= 1)
        sprintf (cardInfo.errorText, 'spcMSetupAnalogPathInputCh: diffInput must be 0 (disable) or 1 (enable)');
        success = false;
        return;
    end
    
    error = 0;
    
    error = error + spcm_dwSetParam_i32 (cardInfo.hDrv, mRegs('SPC_PATH0') + channel * 100, path);
    error = error + spcm_dwSetParam_i32 (cardInfo.hDrv, mRegs('SPC_AMP0') + channel * 100, inputRange);
    
    if cardInfo.AI.inputTermAvailable == true
         error = error + spcm_dwSetParam_i32 (cardInfo.hDrv, mRegs('SPC_50OHM0') + channel * 100, term);
    end
   
    if cardInfo.AI.ACCouplingAvailable == true
         error = error + spcm_dwSetParam_i32 (cardInfo.hDrv, mRegs('SPC_ACDC0') + channel * 100, ACCoupling);
    end
    
    if cardInfo.AI.BWLimitAvailable == true
         error = error + spcm_dwSetParam_i32 (cardInfo.hDrv, mRegs('SPC_FILTER0') + channel * 100, BWLimit);
    end
    
    if cardInfo.AI.diffModeAvailable == true 
        error = error + spcm_dwSetParam_i32 (cardInfo.hDrv, mRegs('SPC_DIFF0') + channel * 100,  diffInput);
    end
    
    % ----- store some information in the structure -----
    cardInfo.AI.setRange(channel+1)  = inputRange;
    cardInfo.AI.setOffset(channel+1) = 0;
    
    [success, cardInfo] = spcMCheckSetError (error, cardInfo);    


























    
