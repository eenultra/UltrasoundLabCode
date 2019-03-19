%**************************************************************************
% Spectrum Matlab Library Package               (c) Spectrum GmbH, 2018
%**************************************************************************
% Supplies different common functions for Matlab programs accessing the 
% SpcM driver interface. Feel free to use this source for own projects and
% modify it in any kind
%**************************************************************************
% spcMSetupDigitalOutput:
% allows all digital output channel related settings
%**************************************************************************

function [success, cardInfo] = spcMSetupDigitalOutput (cardInfo, group, stopMode, lowLevel, highLevel, diffMode)

	global mRegs;
    if (isempty (mRegs))
        mRegs = spcMCreateRegMap ();
    end

    error = 0;

    % check for programmable gain
    if cardInfo.DIO.stopLevelProgrammable == true
        error = error + spcm_dwSetParam_i32 (cardInfo.hDrv, mRegs('SPC_CH0_STOPLEVEL') + group, stopMode);
    end
    
    % check for programmable output level
    if cardInfo.DIO.outputLevelProgrammable == true
        error = error + spcm_dwSetParam_i32 (cardInfo.hDrv, mRegs('SPC_LOWLEVEL0') + group, lowLevel);
        error = error + spcm_dwSetParam_i32 (cardInfo.hDrv, mRegs('SPC_HIGHLEVEL0') + group, highLevel);
    end
    
    if cardInfo.DIO.diffModeAvailable == true
        % to be done
    end
    
   [success, cardInfo] = spcMCheckSetError (error, cardInfo);    