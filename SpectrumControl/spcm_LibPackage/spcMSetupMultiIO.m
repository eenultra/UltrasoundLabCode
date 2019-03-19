%**************************************************************************
% Spectrum Matlab Library Package               (c) Spectrum GmbH, 2018
%**************************************************************************
% Supplies different common functions for Matlab programs accessing the 
% SpcM driver interface. Feel free to use this source for own projects and
% modify it in any kind
%**************************************************************************
% spcMSetupMultiIO:
% defines the M3i, M4i multi purpose i/o usage
%**************************************************************************

function [success, cardInfo] = spcMSetupMultiIO (cardInfo, modeX0, modeX1, modeX2)

	global mRegs;
    if (isempty (mRegs))
        mRegs = spcMCreateRegMap ();
    end

    error = 0;

    error = error + spcm_dwSetParam_i32 (cardInfo.hDrv, mRegs('SPCM_X0_MODE'), modeX0);
    error = error + spcm_dwSetParam_i32 (cardInfo.hDrv, mRegs('SPCM_X1_MODE'), modeX1);
    
    if nargin > 3
        error = error + spcm_dwSetParam_i32 (cardInfo.hDrv, mRegs('SPCM_X2_MODE'), modeX2);
    end
        
    [success, cardInfo] = spcMCheckSetError (error, cardInfo);



    



