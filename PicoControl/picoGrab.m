%% Modified from the example, PS5000A_ID_RAPID_BLOCK_EXAMPLE.M 
% This code uses the |runBlock()| function in order to collect a block of
% data - if other code needs to be executed while waiting for the device to
% indicate that it is ready, use the |ps5000aRunBlock()| function and poll
% the |ps5000aIsReady()| function until the device indicates that it has
% data available for retrieval.

% Capture the blocks of data:

% segmentIndex : 0 

[status.runBlock, timeIndisposedMs] = invoke(blockGroupObj, 'runBlock', 0);

% Retrieve rapid block data values:

downsamplingRatio       = 1;
downsamplingRatioMode   = ps5000aEnuminfo.enPS5000ARatioMode.PS5000A_RATIO_MODE_NONE;

% Provide additional output arguments for the remaining channels e.g. chC
% for Channel C
[numSamples, overflow, chA, chB] = invoke(rapidBlockGroupObj, 'getRapidBlockData', numCaptures, ...
                                    downsamplingRatio, downsamplingRatioMode);

%% Obtain the number of captures

[status.getNoOfCaptures, numCaptures] = invoke(rapidBlockGroupObj, 'ps5000aGetNoOfCaptures');

%% Process data
% Plot data values.
%
% Calculate the time period over which samples were taken for each waveform.
% Use the |timeIntNs| output from the |ps5000aGetTimebase2()| function or
% calculate the sampling interval using the main Programmer's Guide.
% Take into account the downsampling ratio used.

timeNs = double(timeIntervalNanoseconds) * downsamplingRatio * double(0:numSamples - 1);

if picoShow == 1

    % Channel A
    figure1 = figure('Name','PicoScope 5000 Series (A API) Example - Rapid Block Mode Capture', ...
        'NumberTitle', 'off');

    plot(timeNs, chA);
    title('Channel A');
    xlabel('Time (ns)');
    ylabel('Voltage (mV)');
    grid on;
    movegui(figure1, 'west');

    % Channel B
    figure2  = figure('Name','PicoScope 5000 Series (A API) Example - Rapid Block Mode Capture', ...
        'NumberTitle', 'off');

    plot(timeNs, chB);
    title('Channel B - Rapid Block Capture');
    xlabel('Time (ns)');
    ylabel('Voltage (mV)')
    grid on;
    movegui(figure2, 'east');
    
end