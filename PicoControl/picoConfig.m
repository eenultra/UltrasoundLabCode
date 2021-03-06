
% Modified from the example, PS5000A_ID_RAPID_BLOCK_EXAMPLE.M 
% Config card for aquistion.

numCaptures = 10; % Set number of captures - can be less than or equal to the number of segments.
trigCh      = 1; % 0-ChA, 1-ChB, 4-EXT define trig channel
trigLevel   = 500; %mV - rising edge trig level
%Avaliable Dynamic Ranges
%PS5000A_10MV: 0, PS5000A_20MV: 1, PS5000A_50MV: 2, PS5000A_100MV: 3, PS5000A_200MV: 4, PS5000A_500MV: 5
%PS5000A_1V: 6, PS5000A_2V: 7 PS5000A_5V: 8, PS5000A_10V: 9,PS5000A_20V: 10,PS5000A_50V: 11,PS5000A_MAX_RANGES: 12
ChARng      = 5; % set range for ChA -5 for beamplot at 50mV - 8 for pk p
ChBRng      = 8; % set range for ChB -8 for beamplot at 50mV -10 for pk p
nMaxSamp    = 2^13; % Freq set to 1 GS/s, can not exceed nMaxSamples -2^13 for beamplot
nPreTrig    = 128;
nPosTrig    = nMaxSamp - nPreTrig;

%% Set channels
% Default driver settings applied to channels are listed below - use the
% Instrument Driver's |ps5000aSetChannel()| function to turn channels on or
% off and set voltage ranges, coupling, as well as analog offset.

% In this example, data is collected on channels A and B. If it is a
% 4-channel model, channels C and D will be switched off if the power
% supply is connected.

% Channels       : 0 - 1 (ps5000aEnuminfo.enPS5000AChannel.PS5000A_CHANNEL_A & PS5000A_CHANNEL_B)
% Enabled        : 1 (PicoConstants.TRUE)
% Type           : 1 (ps5000aEnuminfo.enPS5000ACoupling.PS5000A_DC)
% Range          : 8 (ps5000aEnuminfo.enPS5000ARange.PS5000A_5V)
% Analog Offset  : 0.0 V

% Channels       : 2 - 3 (ps5000aEnuminfo.enPS5000AChannel.PS5000A_CHANNEL_C & PS5000A_CHANNEL_D)
% Enabled        : 0 (PicoConstants.FALSE)
% Type           : 1 (ps5000aEnuminfo.enPS5000ACoupling.PS5000A_DC)
% Range          : 8 (ps5000aEnuminfo.enPS5000ARange.PS5000A_5V)
% Analog Offset  : 0.0 V

% Find current power source
[status.currentPowerSource] = invoke(ps5000aDeviceObj, 'ps5000aCurrentPowerSource');

    status.setChA = invoke(ps5000aDeviceObj, 'ps5000aSetChannel', 0, 1, 1, ChARng, 0.0);
    status.setChB = invoke(ps5000aDeviceObj, 'ps5000aSetChannel', 1, 1, 1, ChBRng, 0.0);

if (ps5000aDeviceObj.channelCount == PicoConstants.QUAD_SCOPE && status.currentPowerSource == PicoStatus.PICO_POWER_SUPPLY_CONNECTED)
    
    [status.setChC] = invoke(ps5000aDeviceObj, 'ps5000aSetChannel', 2, 0, 1, 8, 0.0);
    [status.setChD] = invoke(ps5000aDeviceObj, 'ps5000aSetChannel', 3, 0, 1, 8, 0.0);
    
end

%% Set device resolution

% resolution : 14bits

[status.setDeviceResolution, resolution] = invoke(ps5000aDeviceObj, 'ps5000aSetDeviceResolution', 14);

%% Set memory segments
% Configure the number of memory segments and query |ps5000aMemorySegments()|
% to find the maximum number of samples for each segment.

% nSegments : 64

nSegments = 64;
[status.memorySegments, nMaxSamples] = invoke(ps5000aDeviceObj, 'ps5000aMemorySegments', nSegments);

% Set number of samples to collect pre- and post-trigger. Ensure that the
% total does not exceeed nMaxSamples above.

if nMaxSamp > nMaxSamples
    disp('Requested data length too large')
    return
end

set(ps5000aDeviceObj, 'numPreTriggerSamples', nPreTrig);
set(ps5000aDeviceObj, 'numPostTriggerSamples', nPosTrig);

%% Verify timebase index and maximum number of samples
% Use the |ps5000aGetTimebase2()| function to query the driver as to the
% suitability of using a particular timebase index and the maximum number
% of samples available in the segment selected, then set the |timebase|
% property if required.
%
% To use the fastest sampling interval possible, enable one analog
% channel and turn off all other channels.
%
% Use a while loop to query the function until the status indicates that a
% valid timebase index has been selected. In this example, the timebase
% index of 4 is valid.

% Initial call to ps5000aGetTimebase2() with parameters:
%
% timebase      : 4
% segment index : 0

status.getTimebase2 = PicoStatus.PICO_INVALID_TIMEBASE;
timebaseIndex = 4;

while (status.getTimebase2 == PicoStatus.PICO_INVALID_TIMEBASE)
    
    [status.getTimebase2, timeIntervalNanoseconds, maxSamples] = invoke(ps5000aDeviceObj, ...
                                                                    'ps5000aGetTimebase2', timebaseIndex, 0);
    
    if (status.getTimebase2 == PicoStatus.PICO_OK)
       
        break;
        
    else
        
        timebaseIndex = timebaseIndex + 1;
        
    end    
    
end

fprintf('Timebase index: %d, sampling interval: %d ns\n', timebaseIndex, timeIntervalNanoseconds);

% Configure the device object's |timebase| property value.
set(ps5000aDeviceObj, 'timebase', timebaseIndex);

%% Set simple trigger
% Set a trigger on channel A, with an auto timeout - the default value for
% delay is used. The device will wait for a rising edge through
% the specified threshold unless the timeout occurs first.

% Trigger properties and functions are located in the Instrument
% Driver's Trigger group.

triggerGroupObj = get(ps5000aDeviceObj, 'Trigger');
triggerGroupObj = triggerGroupObj(1);

% Set the |autoTriggerMs| property in order to automatically trigger the
% oscilloscope after 1 second if a trigger event has not occurred. Set to 0
% to wait indefinitely for a trigger event.

set(triggerGroupObj, 'autoTriggerMs', 0);

% Channel     : 0 (ps5000aEnuminfo.enPS5000AChannel.PS5000A_CHANNEL_A)
% Threshold   : 500 mV
% Direction   : 2 (ps5000aEnuminfo.enPS5000AThresholdDirection.PS5000A_RISING)

[status.setSimpleTrigger] = invoke(triggerGroupObj, 'setSimpleTrigger', trigCh, trigLevel, 2);

%% Set rapid block parameters and capture data
% Capture a number of waveof and retrieve data values for channels A and B.

% Rapid Block specific properties and functions are located in the
% Instrument Driver's Rapidblock group.

rapidBlockGroupObj = get(ps5000aDeviceObj, 'Rapidblock');
rapidBlockGroupObj = rapidBlockGroupObj(1);

% Block specific properties and functions are located in the Instrument
% Driver's Block group.

blockGroupObj = get(ps5000aDeviceObj, 'Block');
blockGroupObj = blockGroupObj(1);


[status.setNoOfCaptures] = invoke(rapidBlockGroupObj, 'ps5000aSetNoOfCaptures', numCaptures);
