%**************************************************************************
% Spectrum Matlab Library Package              (c) Spectrum GmbH, 2018
%**************************************************************************
% Supplies different common functions for Matlab programs accessing the 
% SpcM driver interface. Feel free to use this source for own projects and
% modify it in any kind
%**************************************************************************
% spcMSetupSequenceStep:
% condition = 0 => End loop always
% condition = 1 => End loop on trigger
% condition = 2 => End sequence
%**************************************************************************

function [success, cardInfo] = spcMSetupSequenceStep (cardInfo, step, nextStep, segment, loops, condition)
    
	global mRegs;
    if (isempty (mRegs))
        mRegs = spcMCreateRegMap ();
    end
	
    error = 0;
    
    if (condition == 1) | (condition == 2)
        if condition == 1
            condition = bitshift (condition, 30);
        else
            condition = 1;
            condition = bitshift (condition, 31);
        end
    else
        condition = 0;
    end
    
    valueHigh = bitor (condition, loops);

    nextStep = bitshift (nextStep, 16);
    valueLow = bitor (nextStep, segment);
    
    error = spcm_dwSetParam_i64m (cardInfo.hDrv, mRegs('SPC_SEQMODE_STEPMEM0') + step, valueHigh, valueLow);
    
    [success, cardInfo] = spcMCheckSetError (error, cardInfo);
   