%**************************************************************************
% Spectrum Matlab Library Package              (c) Spectrum GmbH, 2018
%**************************************************************************
% Supplies different common functions for Matlab programs accessing the 
% SpcM driver interface. Feel free to use this source for own projects and
% modify it in any kind
%**************************************************************************
% spcMSetupAnalogOutputChannel:
% allows all analog output channel related settings
%**************************************************************************

function [success, cardInfo] = spcMSetupAnalogOutputChannel (cardInfo, channel, amplitude, outputOffset, filter, stopMode, doubleOut, differential)
    
	global mRegs;
    if (isempty (mRegs))
        mRegs = spcMCreateRegMap ();
    end
	
    if (channel < 0) | (channel >= cardInfo.maxChannels)
        sprintf (cardInfo.errorText, 'spcMSetupInputChannel: channel number %d not valid. Channels range from 0 to %d\n', channel, cardInfo.maxChannels);
        success = false;
        return;
    end
    
    if (doubleOut ~= 0) & (doubleOut ~= 1)
        sprintf (cardInfo.errorText, 'spcMSetupInputChannel: doubleOut must be 0 (disable) or 1 (enable)');
        success = false;
        return;
    end
    
    if (differential ~= 0) & (differential ~= 1)
        sprintf (cardInfo.errorText, 'spcMSetupInputChannel: differential must be 0 (disable) or 1 (enable)');
        success = false;
        return;
    end
        
    error = 0;
   
    % check for programmable gain
    if cardInfo.AO.gainProgrammable == true
        error = error + spcm_dwSetParam_i32 (cardInfo.hDrv, mRegs('SPC_AMP0') + channel * 100, amplitude);
    end
    
    % check for programmable offset
    if cardInfo.AO.offsetProgrammable == true
        error = error + spcm_dwSetParam_i32 (cardInfo.hDrv, mRegs('SPC_OFFS0') + channel * 100, outputOffset);
    end
    
    % check for programmable filters
    if cardInfo.AO.filterAvailable == true
        error = error + spcm_dwSetParam_i32 (cardInfo.hDrv, mRegs('SPC_FILTER0') + channel * 100, filter);
    end
    
    % check for programmable stop levels
    if cardInfo.AO.stopLevelProgrammable == true
        error = error + spcm_dwSetParam_i32 (cardInfo.hDrv, mRegs('SPC_CH0_STOPLEVEL') + channel, stopMode);
    end
    
    % check for programmable diffmodes
    if (cardInfo.AO.diffModeAvailable == true) & (doubleOut == false)
        error = error + spcm_dwSetParam_i32 (cardInfo.hDrv, mRegs('SPC_DIFF0') + channel * 100, differential);
    end
    
    % check for programmable doublemodes
    if (cardInfo.AO.diffModeAvailable == true) & (differential == false)
        error = error + spcm_dwSetParam_i32 (cardInfo.hDrv, mRegs('SPC_DOUBLEOUT0') + channel * 100, doubleOut);
    end
    
    % enable output channel (M4i)
    if cardInfo.isM4i == true
        error = error + spcm_dwSetParam_i32 (cardInfo.hDrv, mRegs('SPC_ENABLEOUT0') + channel * 100, 1);
    end
    
    [success, cardInfo] = spcMCheckSetError (error, cardInfo);    
