%% Modified from the example, PS5000A_ID_RAPID_BLOCK_EXAMPLE.M 

%% Stop the device

[status.stop] = invoke(ps5000aDeviceObj, 'ps5000aStop');

%% Disconnect device
% Disconnect device object from hardware.

disconnect(ps5000aDeviceObj);
delete(ps5000aDeviceObj);