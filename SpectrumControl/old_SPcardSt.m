% Single card setup for Spectrum DAQ
%
% July 2014
% James McLaughlan
% ns give the int number of 4.096 us (1024 samples @ 250 MHz)
% drCh0 dynamic range on Ch0 in mV
% drCh1 dynamic range on Ch1 in mV
% e.g. SPcardSt(500,1000,8)

function SPcardSt(drCh0,drCh1,ns)

global cardInfo

%drCh0 = 500;  % dynamic range on Ch0 in mV
%drCh1 = 1000; % dynamic range on Ch1 in mV

try
    cardInfo.maxChannels;
    fprintf('\nCard Found');
catch
    % single card
    deviceString = '/dev/spcm0';
    [success, cardInfo] = spcMInitDevice (deviceString);  
    if (success == true)
        % ----- print info about the board -----
        cardInfoText = spcMPrintCardInfo (cardInfo);
        fprintf (cardInfoText);
    else
        spcMErrorMessageStdOut (cardInfo, 'Error: Could not open card\n', true);
        return;
    end
end

%errorCode = spcm_dwSetParam_i64 (cardInfo.hDrv, 100, 1); % card reset

% ***** do card setup *****
cardInfo.ns     = ns * 1024 ; %
cardInfo.pre_ns = 128;

% ----- set channel mask for max channels ----
    chMaskH = 0;
    chMaskL = bitshift (1, cardInfo.maxChannels) - 1;
%[success, cardInfo] = spcMSetupModeRecStdSingle (cardInfo, chEnableH, chEnableL, memSamples, postSamples)    
[success, cardInfo] = spcMSetupModeRecStdSingle (cardInfo, chMaskH, chMaskL, cardInfo.ns, cardInfo.ns-cardInfo.pre_ns);
% if (success == false)
%     spcMErrorMessageStdOut (cardInfo, 'Error: spcMSetupModeRecStdSingle:\n\t', true);
%     return;
% end

% ----- set samplerate to the max samplerate of the card, if max samplerate is less than 10 MHz -----
[success, cardInfo] = spcMSetupClockPLL (cardInfo, cardInfo.maxSamplerate, 0); % clock output : enable = 1, disable = 0
% if (success == false)
%     spcMErrorMessageStdOut (cardInfo, 'Error: spcMSetupClockPLL:\n\t', true);
%     return;
% end
%[success, cardInfo] = spcMSetupClockPLL (cardInfo, selectSampleRate, 0);


% ----- we set software trigger, no trigger output -----
%[success, cardInfo] = spcMSetupTrigSoftware (cardInfo, 0);  % trigger output : enable = 1, disable = 0
% ----- we set trigger to external positive edge, please connect the trigger line! -----
% ----- extMode = 1, trigTerm = 0, pulseWidth = 0, singleSrc = 1, extLine = 0 -----
[success, cardInfo] = spcMSetupTrigExternal (cardInfo, 1, 0, 0, 1, 0);  % 1 = SPC_TM_POS
%[success, cardInfo] = spcMSetupTrigSoftware (cardInfo, 0); % trigger output : enable = 1, disable = 0

% ----- program all input channels to +/-1 V and 50 ohm termination (if it's available) -----

[success, cardInfo] = spcMSetupAnalogInputChannel (cardInfo, 0, drCh0, 1, 0, 0); % Set up Ch0 :cardInfo, channel, inputRange, term(0-1MOhm,1=50Ohm), inputOffset, diffInput
[success, cardInfo] = spcMSetupAnalogInputChannel (cardInfo, 1, drCh1, 1, 0, 0);% Set up Ch1 :cardInfo, channel, inputRange, term(0-1MOhm,1=50Ohm), inputOffset, diffInput

%[success, cardInfo] = spcMSetupAnalogPathInputCh (cardInfo, 0, path, drCh0, 1, ACCoupning, BWLimit,diffInput);Set up Ch0 :cardInfo, channel, path, inputRange, term(0-1MOhm,1=50Ohm), ACCoupning, BWLimit,diffInput


% if (success == false)
%     spcMErrorMessageStdOut (cardInfo, 'Error: spcMSetupInputChannel:\n\t', true);
%     return;
% end

fprintf ('\nCard Configured\n'); 
fprintf ('Sampling rate set to %.1f MHz\n', cardInfo.setSamplerate / 1000000);
fprintf ('Dynamic Range Ch0: %.1f mV\nDynamic Range Ch1: %.1f mV\n',drCh0,drCh1);
fprintf ('Post trigger acquisition time %.1f us\n', (cardInfo.ns/cardInfo.setSamplerate)*1E6);