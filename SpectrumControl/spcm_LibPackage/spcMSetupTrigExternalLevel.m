%**************************************************************************
% Spectrum Matlab Library Package               (c) Spectrum GmbH, 2018
%**************************************************************************
% Supplies different common functions for Matlab programs accessing the 
% SpcM driver interface. Feel free to use this source for own projects and
% modify it in any kind
%**************************************************************************
% spcMSetupTrigExternalLevel:
% external trigger with comparator levels
%**************************************************************************

function [success, cardInfo] = spcMSetupTrigExternalLevel (cardInfo, extMode, level0, level1, trigTerm, ACCoupling, pulsewidth, singleSrc, extLine)
    
	global mRegs;
    if (isempty (mRegs))
        mRegs = spcMCreateRegMap ();
    end
	
    error = 0;
    
    % ----- not supported by M2i and M2i Express cards as they have plain TTL trigger
    if or ((bitand (cardInfo.cardType, mRegs('TYP_SERIESMASK')) == mRegs('TYP_M2ISERIES')), (bitand (cardInfo.cardType, mRegs('TYP_SERIESMASK')) == mRegs('TYP_M2IEXPSERIES')))
        sprintf (cardInfo.errorText, 'spcMSetupTrigExternalLevel: function not supported on M2i and M2i-Express cards\n');
        success = false;
        return;
    end
    
    % ----- setup the external trigger mode -----
    error = error + spcm_dwSetParam_i32 (cardInfo.hDrv, mRegs('SPC_TRIG_EXT0_MODE') + extLine, extMode);
    error = error + spcm_dwSetParam_i32 (cardInfo.hDrv, mRegs('SPC_TRIG_TERM0') + extLine, trigTerm);
    error = error + spcm_dwSetParam_i32 (cardInfo.hDrv, mRegs('SPC_TRIG_EXT0_ACDC') + extLine, ACCoupling);
       
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
    
    % ----- Ext0 needs trigger levels -----
    if extLine == 0
        error = error + spcm_dwSetParam_i32 (cardInfo.hDrv, mRegs('SPC_TRIG_EXT0_LEVEL0'), level0);
        error = error + spcm_dwSetParam_i32 (cardInfo.hDrv, mRegs('SPC_TRIG_EXT0_LEVEL1'), level1);
    end
            
    [success, cardInfo] = spcMCheckSetError (error, cardInfo);    

    

