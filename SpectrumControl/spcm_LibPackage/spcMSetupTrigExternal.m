%**************************************************************************
% Spectrum Matlab Library Package               (c) Spectrum GmbH, 2018
%**************************************************************************
% Supplies different common functions for Matlab programs accessing the 
% SpcM driver interface. Feel free to use this source for own projects and
% modify it in any kind
%**************************************************************************
% spcMSetupTrigExternal:
% external trigger
%**************************************************************************

function [success, cardInfo] = spcMSetupTrigExternal (cardInfo, extMode, trigTerm, pulsewidth, singleSrc, extLine)
    
	global mRegs;
    if (isempty (mRegs))
        mRegs = spcMCreateRegMap ();
    end
	
    error = 0;
    
    % ----- setup the external trigger mode -----
    error = error + spcm_dwSetParam_i32 (cardInfo.hDrv, mRegs('SPC_TRIG_EXT0_MODE') + extLine, extMode);
    error = error + spcm_dwSetParam_i32 (cardInfo.hDrv, mRegs('SPC_TRIG_TERM') + extLine, trigTerm);

    % ----- we only use trigout on M2i cards as we otherwise would override the multi purpose i/o lines of M3i 
    if or ((bitand (cardInfo.cardType, mRegs('TYP_SERIESMASK')) == mRegs('TYP_M2ISERIES')), (bitand (cardInfo.cardType, mRegs('TYP_SERIESMASK')) == mRegs('TYP_M2IEXPSERIES')))
        error = error + spcm_dwSetParam_i32 (cardInfo.hDrv, mRegs('SPC_TRIG_EXT0_PULSEWIDTH') + extLine, pulsewidth);
        error = error + spcm_dwSetParam_i32 (cardInfo.hDrv, mRegs('SPC_TRIG_OUTPUT'), 0);
    end
       

    % ----- set masks if single source is activated -----
    if singleSrc == 1
        switch (extLine)
            case 0
                error = error + spcm_dwSetParam_i32 (cardInfo.hDrv, mRegs('SPC_TRIG_ORMASK'), mRegs('SPC_TMASK_EXT0'));
            case 1
                error = error + spcm_dwSetParam_i32 (cardInfo.hDrv, mRegs('SPC_TRIG_ORMASK'), mRegs('SPC_TMASK_EXT1'));
            case 2
                error = error + spcm_dwSetParam_i32 (cardInfo.hDrv, mRegs('SPC_TRIG_ORMASK'), mRegs('SPC_TMASK_EXT2'));
        end
                
        error = error + spcm_dwSetParam_i32 (cardInfo.hDrv, mRegs('SPC_TRIG_ANDMASK'),     0);
        error = error + spcm_dwSetParam_i32 (cardInfo.hDrv, mRegs('SPC_TRIG_CH_ORMASK0'),  0);
        error = error + spcm_dwSetParam_i32 (cardInfo.hDrv, mRegs('SPC_TRIG_CH_ORMASK1'),  0);
        error = error + spcm_dwSetParam_i32 (cardInfo.hDrv, mRegs('SPC_TRIG_CH_ANDMASK0'), 0);
        error = error + spcm_dwSetParam_i32 (cardInfo.hDrv, mRegs('SPC_TRIG_CH_ANDMASK1'), 0);
    end
    
    % ----- M3i cards need trigger level to be programmed for Ext0 = analog trigger
    if or ((bitand (cardInfo.cardType, mRegs('TYP_SERIESMASK')) == mRegs('TYP_M3ISERIES')), (bitand (cardInfo.cardType, mRegs('TYP_SERIESMASK')) == mRegs('TYP_M3IEXPSERIES')))
        error = error + spcm_dwSetParam_i32 (cardInfo.hDrv, mRegs('SPC_TRIG_EXT0_LEVEL0'), 1500);
        error = error + spcm_dwSetParam_i32 (cardInfo.hDrv, mRegs('SPC_TRIG_EXT0_LEVEL1'), 800);
    end
            
    [success, cardInfo] = spcMCheckSetError (error, cardInfo);    

    

