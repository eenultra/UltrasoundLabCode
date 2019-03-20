% Arm and aquire a single data set with card
% This is only used after the card has been configured by daqStSingleAq

% James McLaughlan
% University of Leeds
% March 2019


function [t,DAT]= daqSAqu

global cardInfo

DAT = zeros(cardInfo.setMemsize,cardInfo.setChannels);

% ----- set time array for display -----
t = linspace(-cardInfo.pre_lDat/cardInfo.maxSamplerate,cardInfo.lDat/cardInfo.maxSamplerate,cardInfo.setMemsize)*1E6;

% ***** start card for acquistion *****
% ----- we'll start and wait until the card has finished or until a timeout occurs -----
timeout_ms = 10000;
errorCode = spcm_dwSetParam_i64 (cardInfo.hDrv, 295130, timeout_ms);  % 295130 = SPC_TIMEOUT
if (errorCode ~= 0)
    [~, cardInfo] = spcMCheckSetError (errorCode, cardInfo);
    spcMErrorMessageStdOut (cardInfo, 'Error: spcm_dwSetParam_i32:\n\t', true);
    return;
end

%fprintf ('\nCard timeout is set to %d ms\n', timeout_ms);
%fprintf ('Starting the card and waiting for ready interrupt ...\n');

% ----- set command flags -----
commandMask = bitor (4, 8);                %   M2CMD_CARD_START | M2CMD_CARD_ENABLETRIGGER
commandMask = bitor (commandMask, 16384);  % | M2CMD_CARD_WAITREADY

errorCode = spcm_dwSetParam_i64 (cardInfo.hDrv, 100, commandMask);  % 100 = SPC_M2CMD commandMask

if ((errorCode ~= 0) && (errorCode ~= 263))
    [~, cardInfo] = spcMCheckSetError (errorCode, cardInfo);
    spcMErrorMessageStdOut (cardInfo, 'Error: spcm_dwSetParam_i32:\n\t', true);
    return;
end


if errorCode == 263  % 263 = ERR_TIMEOUT   
   spcMErrorMessageStdOut (cardInfo, '... Timeout occurred !!!', false);
   SPcardEn;
   return;
else

    % ***** transfer data from card to PC memory *****
    %fprintf ('Starting the DMA transfer and waiting for trigger ...\n');
    dataType = 1; 
    switch cardInfo.setChannels
            %[dwErrorCode, Dat_Ch0, Dat_Ch1] = spcm_dwGetData (hDrv, dwOffs, dwLen, dwChannels, dwDataType);
            case 1
                % ----- get the whole data for one channel with offset = 0 ----- 
                [errorCode, Dat_Ch0] = spcm_dwGetData (cardInfo.hDrv, 0, cardInfo.setMemsize, cardInfo.setChannels, dataType);
                DAT = Dat_Ch0;
            case 2
                % ----- get the whole data for two channels with offset = 0 ----- 
                [errorCode, Dat_Ch0, Dat_Ch1] = spcm_dwGetData (cardInfo.hDrv, 0, cardInfo.setMemsize, cardInfo.setChannels, dataType);
                DAT(:,1) = Dat_Ch0;
                DAT(:,2) = Dat_Ch1;
    end
    
end