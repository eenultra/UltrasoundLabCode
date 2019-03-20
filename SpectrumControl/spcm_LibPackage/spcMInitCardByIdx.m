%**************************************************************************
% Spectrum Matlab Library Package               (c) Spectrum GmbH, 2018
%**************************************************************************
% Supplies different common functions for Matlab programs accessing the 
% SpcM driver interface. Feel free to use this source for own projects and
% modify it in any kind
%**************************************************************************
% spcMInitCardByIdx
% opens the driver with the given index, reads out card information and
% returns a filled cardInfo structure
%**************************************************************************

function [success, cardInfo] = spcMInitCardByIdx (cardIdx)
    
	global mRegs;
    if (isempty (mRegs))
        mRegs = spcMCreateRegMap ();
    end
	
    %open the driver for the card. We can use the linux notation here as the windows driver only looks for the ending number. 
    drvName = sprintf ('/dev/spcm%d', cardIdx);
    cardInfo.hDrv = spcm_hOpen (drvName);
    
    if (cardInfo.hDrv == 0)
        [errorCode, errorReg, errorVal, cardInfo.errorText] = spcm_dwGetErrorInfo_i32 (cardInfo.hDrv);
        success = false;
        return;
    end
    
    cardInfo.setChannels     = 1;
    cardInfo.setSamplerate   = 1;
    cardInfo.setMemsize      = 0;
    cardInfo.setChEnableHMap = 0;
    cardInfo.setChEnableLMap = 0;
    cardInfo.oversampling    = 1;
    
    % read out card information and store it in the card info structure
    [errorCode, cardInfo.cardType]       = spcm_dwGetParam_i32 (cardInfo.hDrv, mRegs('SPC_PCITYP'));
    [errorCode, cardInfo.serialNumber]   = spcm_dwGetParam_i32 (cardInfo.hDrv, mRegs('SPC_PCISERIALNO'));
    [errorCode, cardInfo.featureMap]     = spcm_dwGetParam_i32 (cardInfo.hDrv, mRegs('SPC_PCIFEATURES'));
    [errorCode, cardInfo.instMemBytes]   = spcm_dwGetParam_i64 (cardInfo.hDrv, mRegs('SPC_PCIMEMSIZE'));
    [errorCode, cardInfo.minSamplerate]  = spcm_dwGetParam_i32 (cardInfo.hDrv, mRegs('SPC_MIINST_MINADCLOCK'));
    [errorCode, cardInfo.maxSamplerate]  = spcm_dwGetParam_i64 (cardInfo.hDrv, mRegs('SPC_MIINST_MAXADCLOCK'));
    [errorCode, cardInfo.modulesCount]   = spcm_dwGetParam_i32 (cardInfo.hDrv, mRegs('SPC_MIINST_MODULES'));
    [errorCode, cardInfo.maxChannels]    = spcm_dwGetParam_i32 (cardInfo.hDrv, mRegs('SPC_MIINST_CHPERMODULE'));
    [errorCode, cardInfo.bytesPerSample] = spcm_dwGetParam_i32 (cardInfo.hDrv, mRegs('SPC_MIINST_BYTESPERSAMPLE'));
    [errorCode, cardInfo.libVersion]     = spcm_dwGetParam_i32 (cardInfo.hDrv, mRegs('SPC_GETDRVVERSION'));
    [errorCode, cardInfo.kernelVersion]  = spcm_dwGetParam_i32 (cardInfo.hDrv, mRegs('SPC_GETKERNELVERSION'));

    % we need to recalculate the channels value as the driver returns channels per module
    cardInfo.maxChannels = cardInfo.maxChannels * cardInfo.modulesCount;
    
	% set family type
	cardInfo.isM2i = false;
	cardInfo.isM3i = false;
	cardInfo.isM4i = false;
	cardInfo.isM2p = false;
	
	switch bitand (cardInfo.cardType, mRegs('TYP_SERIESMASK'))
	 
		case mRegs('TYP_M2ISERIES')
			cardInfo.isM2i = true;
		case mRegs('TYP_M2IEXPSERIES')
			cardInfo.isM2i = true;
		case mRegs('TYP_M3ISERIES')
			cardInfo.isM3i = true;
		case mRegs('TYP_M3IEXPSERIES')
			cardInfo.isM3i = true;
		case mRegs('TYP_M4IEXPSERIES')
			cardInfo.isM4i = true;
		case mRegs('TYP_M4XEXPSERIES')
            cardInfo.isM4i = true;
        case mRegs('TYP_M2PEXPSERIES')
            cardInfo.isM2p = true;
	end	
			
    % examin the type of driver
    [errorCode, cardInfo.cardFunction] = spcm_dwGetParam_i32 (cardInfo.hDrv, mRegs('SPC_FNCTYPE'));
    
    % loading the function dependant part of the CardInfo structure
    switch cardInfo.cardFunction
        
        % AnalogIn
        case mRegs('SPCM_TYPE_AI')
            [errorCode, cardInfo.AI.resolution] = spcm_dwGetParam_i32 (cardInfo.hDrv, mRegs('SPC_MIINST_BITSPERSAMPLE'));
            [errorCode, cardInfo.AI.pathCount] =  spcm_dwGetParam_i32 (cardInfo.hDrv, mRegs('SPC_READAIPATHCOUNT'));
            [errorCode, cardInfo.AI.rangeCount] = spcm_dwGetParam_i32 (cardInfo.hDrv, mRegs('SPC_READIRCOUNT'));
            
            i = 1;
            
            while (i <= cardInfo.AI.rangeCount) && (i <= 8) %corrected due to bug in code
                [errorCode, cardInfo.AI.rangeMin(i)] = spcm_dwGetParam_i32 (cardInfo.hDrv, mRegs('SPC_READRANGEMIN0') + (i - 1));
                [errorCode, cardInfo.AI.rangeMax(i)] = spcm_dwGetParam_i32 (cardInfo.hDrv, mRegs('SPC_READRANGEMAX0') + (i - 1));
                i = i + 1;
            end
            
            [errorCode, AIFeatures] = spcm_dwGetParam_i32 (cardInfo.hDrv, mRegs('SPC_READAIFEATURES'));
            
            if bitand (AIFeatures, mRegs('SPCM_AI_TERM')) ~= 0
                cardInfo.AI.inputTermAvailable = 1; 
            else
                cardInfo.AI.inputTermAvailable = 0;
            end
                
            if bitand (AIFeatures, mRegs('SPCM_AI_DIFF')) ~= 0
                cardInfo.AI.diffModeAvailable = 1;
            else
                cardInfo.AI.diffModeAvailable = 0;
            end
                
            if  bitand (AIFeatures, mRegs('SPCM_AI_OFFSPERCENT')) ~= 0
                cardInfo.AI.offsPercentMode = 1;
            else
                cardInfo.AI.offsPercentMode = 0;
            end
            
            if  bitand (AIFeatures, mRegs('SPCM_AI_ACCOUPLING')) ~= 0
                cardInfo.AI.ACCouplingAvailable = 1;
            else
                cardInfo.AI.ACCouplingAvailable = 0;
            end

            if  bitand (AIFeatures, mRegs('SPCM_AI_LOWPASS')) ~= 0
                cardInfo.AI.BWLimitAvailable = 1;
            else
                cardInfo.AI.BWLimitAvailable = 0;
            end
            
        % AnalogOut
        case mRegs('SPCM_TYPE_AO')
            
            [errorCode, cardInfo.AO.resolution] = spcm_dwGetParam_i32 (cardInfo.hDrv, mRegs('SPC_MIINST_BITSPERSAMPLE'));
            [errorCode, AOFeatures] = spcm_dwGetParam_i32 (cardInfo.hDrv, mRegs('SPC_READAOFEATURES'));
            
            if bitand (AOFeatures, mRegs('SPCM_AO_PROGGAIN')) ~= 0
                cardInfo.AO.gainProgrammable = 1;
            else
                cardInfo.AO.gainProgrammable = 0;
            end
            
            if bitand (AOFeatures, mRegs('SPCM_AO_PROGOFFSET')) ~= 0
                cardInfo.AO.offsetProgrammable = 1;
            else
                cardInfo.AO.offsetProgrammable = 0;
            end

            if bitand (AOFeatures, mRegs('SPCM_AO_PROGFILTER')) ~= 0
                cardInfo.AO.filterAvailable = 1;
            else
                cardInfo.AO.filterAvailable = 0;
            end
            
            if bitand (AOFeatures, mRegs('SPCM_AO_PROGSTOPLEVEL')) ~= 0
                cardInfo.AO.stopLevelProgrammable = 1;
            else
                cardInfo.AO.stopLevelProgrammable = 0;
            end
            
            if bitand (AOFeatures, mRegs('SPCM_AO_DIFF')) ~= 0
                cardInfo.AO.diffModeAvailable = 1;
            else
                cardInfo.AO.diffModeAvailable = 0;
            end
        
        % DigitalIn, DigitalOut, DigitalIO
        case { mRegs('SPCM_TYPE_DI'), mRegs('SPCM_TYPE_DO'), mRegs('SPCM_TYPE_DIO') }
            
            % Digital in
            if (cardInfo.cardFunction == mRegs('SPCM_TYPE_DI')) | (cardInfo.cardFunction == mRegs('SPCM_TYPE_DIO'))
                [errorCode, DIFeatures] = spcm_dwGetParam_i32 (cardInfo.hDrv, mRegs('SPC_READDIFEATURES'));
                
                [errorCode, cardInfo.DIO.groups] = spcm_dwGetParam_i32 (cardInfo.hDrv, mRegs('SPC_READCHGROUPING'));
                cardInfo.DIO.groups = cardInfo.maxChannels / cardInfo.DIO.groups;
                
                if bitand (DIFeatures, mRegs('SPCM_DI_TERM')) ~= 0
                    cardInfo.DIO.inputTermAvailable = 1;
                else
                    cardInfo.DIO.inputTermAvailable = 0;
                end
                
                if bitand (DIFeatures, mRegs('SPCM_DI_DIFF')) ~= 0
                    cardInfo.DIO.diffModeAvailable = 1;
                else
                    cardInfo.DIO.diffModeAvailable = 0;
                end
            end
            
            % Digital out
            if (cardInfo.cardFunction == mRegs('SPCM_TYPE_DO')) | (cardInfo.cardFunction == mRegs('SPCM_TYPE_DIO'))
                [errorCode, DOFeatures] = spcm_dwGetParam_i32 (cardInfo.hDrv, mRegs('SPC_READDOFEATURES'));
                
                if bitand (DOFeatures, mRegs('SPCM_DO_DIFF')) ~= 0
                    cardInfo.DIO.diffModeAvailable = 1;
                else
                    cardInfo.DIO.diffModeAvailable = 0;
                end
                
                if bitand (DOFeatures, mRegs('SPCM_DO_PROGSTOPLEVEL')) ~= 0
                    cardInfo.DIO.stopLevelProgrammable = 1;
                else
                    cardInfo.DIO.stopLevelProgrammable = 0;
                end
                
                if bitand (DOFeatures, mRegs('SPCM_DO_PROGOUTLEVELS')) ~= 0
                    cardInfo.DIO.outputLevelProgrammable = 1;
                else
                    cardInfo.DIO.outputLevelProgrammable = 0;
                end
            end
    end
    
    cardInfo.errorText = 'No Error';
    
    success = true;
           