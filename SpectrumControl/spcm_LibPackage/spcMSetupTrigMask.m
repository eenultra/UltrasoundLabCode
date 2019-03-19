%**************************************************************************
% Spectrum Matlab Library Package               (c) Spectrum GmbH, 2018
%**************************************************************************
% Supplies different common functions for Matlab programs accessing the 
% SpcM driver interface. Feel free to use this source for own projects and
% modify it in any kind
%**************************************************************************
% spcMSetupTrigMask:
% this function sets the trigger masks (singleSrc of other commands must 
% be false to use this)
%**************************************************************************

function [success, cardInfo] = spcMSetupTrigMask (cardInfo, channelOrMask0, channelOrMask1, channelAndMask0, channelAndMask1, trigOrMask, trigAndMask)
    
	lobal mRegs;
    if (isempty (mRegs))
        mRegs = spcMCreateRegMap ();
    end
	
    error = 0;
    
    error = error + spcm_dwSetParam_i32 (cardInfo.hDrv, mRegs('SPC_TRIG_ORMASK'),      trigOrMask);
    error = error + spcm_dwSetParam_i32 (cardInfo.hDrv, mRegs('SPC_TRIG_ANDMASK'),     trigAndMask);
    error = error + spcm_dwSetParam_i32 (cardInfo.hDrv, mRegs('SPC_TRIG_CH_ORMASK0'),  channelOrMask0);
    error = error + spcm_dwSetParam_i32 (cardInfo.hDrv, mRegs('SPC_TRIG_CH_ORMASK1'),  channelOrMask1);
    error = error + spcm_dwSetParam_i32 (cardInfo.hDrv, mRegs('SPC_TRIG_CH_ANDMASK0'), channelAndMask0);
    error = error + spcm_dwSetParam_i32 (cardInfo.hDrv, mRegs('SPC_TRIG_CH_ANDMASK1'), channelAndMask1);
    
    [success, cardInfo] = spcMCheckSetError (error, cardInfo);    




















   
    
   



    

