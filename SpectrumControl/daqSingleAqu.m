% The following example just initializes card zero, reads out some information, prints them, 
% does a simple card setup, starts the card and reads
% out all data of the acquired channel.
% Taken from SPCM MatLab Manual

% University of Leeds
% James McLaughlan
% Mar 2019

[success, cardInfo] = spcMInitCardByIdx (0);

if (success == true)
    fprintf (spcMPrintCardInfo (cardInfo));
    else
    spcMErrorMessageStdOut (cardInfo, 'Error: Could not open card\n', true);
    return;
end

% ***** do card setup *****
[success, cardInfo] = spcMSetupModeRecStdSingle (cardInfo, 0, 1, 16 * 1024, 8 * 1024);
[success, cardInfo] = spcMSetupClockPLL (cardInfo, 10000000, 0);
[success, cardInfo] = spcMSetupTrigSoftware (cardInfo, 0); % trigger output : enable = 1, disable = 0
% ----- set command start and wait ready -----
errorCode = spcm_dwSetParam_i32 (cardInfo.hDrv, 100, 12);
% ----- read the one channel that was acquired as 16 bit integer values -----
[errorCode, Dat_Ch0] = spcm_dwGetData (cardInfo.hDrv, 0, cardInfo.setMemsize, cardInfo.setChannels, 0);
spcMCloseCard (cardInfo);

plot(Dat_Ch0);
