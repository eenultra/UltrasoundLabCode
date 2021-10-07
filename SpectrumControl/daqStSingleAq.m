% Initialise and start the connected Spectrum DAQ card to 
% acquire a single set of data for each received trigger

% James McLaughlan
% University of Leeds
% March 2019

%drCh0 = 500;  % dynamic range on Ch0 in mV
%drCh1 = 1000; % dynamic range on Ch1 in mV
%nDat number of memsize in data
%nCh number of channels in use
%sampleFreq, in MHz
% [Ch0 Ch1] dynamic range for each channel
% [1 1] input impedance for each channel [1]-50ohm, [0]-1MOhm
% trig type, 1 for external, default internal trigger

function daqStSingleAq(nDat,nCh,sampleFreq,drCh,imCh,trigType) %nChannels,

% helper maps to use label names for registers and errors
global mRegs;
global mErrors;
global cardInfo;
 
mRegs = spcMCreateRegMap ();
mErrors = spcMCreateErrorMap ();

if isempty(cardInfo) == 0
    disp('Card already connected, closing...'); 
    spcMCloseCard (cardInfo); %close card if already connected, otherwise it will crash
end

mRegs = spcMCreateRegMap ();
mErrors = spcMCreateErrorMap ();

% ***** use device string to open single card or digitizerNETBOX *****
% digitizerNETBOX
%deviceString = 'TCPIP::XX.XX.XX.XX::inst0'; % XX.XX.XX.XX = IP Address, as an example : 'TCPIP::169.254.119.42::inst0'

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

% ----- check whether we support this card type in the example -----
if (cardInfo.cardFunction ~= mRegs('SPCM_TYPE_AI')) && (cardInfo.cardFunction ~= mRegs('SPCM_TYPE_DI')) && (cardInfo.cardFunction ~= mRegs('SPCM_TYPE_DIO'))
    spcMErrorMessageStdOut (cardInfo, 'Error: Card function not supported by this example\n', false);
    return;
end

% ***** do card setup *****
% ----- set channel mask for max channels -----
if cardInfo.maxChannels == 64
    chMaskH = hex2dec ('FFFFFFFF');
    chMaskL = hex2dec ('FFFFFFFF');
else
    chMaskH = 0;
    chMaskL = bitshift (1, cardInfo.maxChannels) - 1;
end

cardInfo.nDat        = nDat; % number of mem segments used in aquire
cardInfo.lDat        = (nDat-1) * 1024 ; % after trig mem length
cardInfo.setMemsize  = nDat * 1024 ; % total mem length
cardInfo.pre_lDat    = 1024; % pre-mem length 

%[success, cardInfo] = spcMSetupModeRecStdSingle (cardInfo, 0, 1, cardInfo.setMemsize, cardInfo.lDat); %spcMSetupModeRecStdSingle (cardInfo, chEnableH, chEnableL, memSamples, postSamples) - The �chEnableH� (upper 32 channels) and �chEnableL� (lower 32 channels) parameter must form together a valid channel enable mask while �memSamples� and �postSamples� gives memory size and post trigger in samples per channel.

% ----- standard single, all channels,  -----    
[success, cardInfo] = spcMSetupModeRecStdSingle (cardInfo, chMaskH, chMaskL, cardInfo.setMemsize, cardInfo.lDat);
if (success == false)
    spcMErrorMessageStdOut (cardInfo, 'Error: spcMSetupModeRecStdSingle:\n\t', true);
    return;
end

[success, cardInfo] = spcMSetupClockPLL (cardInfo, sampleFreq*1E6, 0);  % clock output : enable = 1, disable = 0
if (success == false)
    spcMErrorMessageStdOut (cardInfo, 'Error: spcMSetupClockPLL:\n\t', true);
    return;
end
    if (success == false)
        spcMErrorMessageStdOut (cardInfo, 'Error: spcMSetupClockPLL:\n\t', true);
        return;
    end

if trigType == 1 % external triggering
     % ----- extMode = SPC_TM_POS, trigTerm = 0, pulseWidth = 0, singleSrc = 1, extLine = 0 -----
     [success, cardInfo] = spcMSetupTrigExternal (cardInfo, mRegs('SPC_TM_POS'), 0, 0, 1, 0); %[success, cardInfo] = spcMSetupTrigExternal (cardInfo, extMode, trigTerm, pulsewidth, singleSrc, extLine);
     %[success, cardInfo] = spcMSetupTrigExternal (cardInfo, extMode, trigTerm, pulsewidth, singleSrc, extLine);
     if (success == false)
         spcMErrorMessageStdOut (cardInfo, 'Error: spcMSetupTrigExternal:\n\t', true);
         return;
     end
     disp('Using external trigger - please connect a signal to the trigger input!');
else
    [success, cardInfo] = spcMSetupTrigSoftware (cardInfo, 0); % trigger output : enable = 1, disable = 0
    disp('Software trigger is selected');
end

%[success, cardInfo] = spcMSetupAnalogPathInputCh (cardInfo, channel, path, inputRange, term, ACCoupning,BWLimit, diffInput);
% The �path� parameter defines the path to be selected. The �inputRange� parameter defines the input range to choose for this channel, the
% �term� parameter switches the programmable input termination (0-1MOhm,1=50Ohm), the �ACCoupling� switches between DC (0) and AC (1) coupling, the
% �BWLimit� parameter activates the bandwidth limiting filter (1) and the �diffInput� switches between single-ended (0) and differential inputs
% (1). As this is an universal function not all cards support all of these parameters. If the card type does not support all of the features these
% settings will simply be ignored.

cardInfo.setChannels = nCh;
for i=1 : cardInfo.setChannels 
    [success, cardInfo] = spcMSetupAnalogPathInputCh (cardInfo, i-1, 0, drCh(i), imCh(i), 0, 0, 0)  
    if (success == false)
        spcMErrorMessageStdOut (cardInfo, 'Error: spcMSetupInputChannel:\n\t', true);
        return;
    end
end

% ----- read the one channel that was acquired as 16 bit integer values -----
%[errorCode, Dat_Ch0] = spcm_dwGetData (cardInfo.hDrv, 0, cardInfo.setMemsize, cardInfo.setChannels, 0);
disp(['Sampling rate set to '  num2str(cardInfo.setSamplerate/1E6) ' MHz']);
disp(['Dynamic Range Ch0: ' num2str(drCh(1)) ' mV, Dynamic Range Ch1: ' num2str(drCh(2)) ' mV']);
disp(['Pre trigger acquisition time ' num2str((cardInfo.pre_lDat/cardInfo.setSamplerate)*1E6) ' us']);
disp(['Post trigger acquisition time ' num2str((cardInfo.lDat/cardInfo.setSamplerate)*1E6) ' us']);
disp('Card Configured'); 

