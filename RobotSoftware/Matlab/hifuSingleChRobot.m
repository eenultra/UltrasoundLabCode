%% Initialise UConfig
% This section clears any existing UARP configurations, and creates a new
% blank UARP configuration with the right simulated hardware for this demo.
UARP.init('HIFUARP');

% Initialise Platform Hardware
UConfig.initialiseHardware();

% Define Logical Transducer
UConfig.newTransducer('H_102', UConfig.Library.Transducer.H_102, 'Sx0002.8');

% Create Procedure

UConfig.newProcedure('expose');

% Number of times to repeat whole procedure.
UConfig.expose.NTimes = 1;

% How to download receive data back from the UARP.
UConfig.expose.DownloadMode = UARP.Constant.DownloadMode.Disabled;

% Set up procedure triggering.
UConfig.expose.Trigger.InMode = 'Internal';
UConfig.expose.Trigger.InPolarity = 'RisingEdge';

% Create Operation
UConfig.expose.newOperation('CW', 'Sequential');

% Repeat the overarching procedure the number of times you want the
% operation to execute with callback.
 UConfig.expose.NTimes = 7;
 UConfig.expose.CW.ExecuteCallback = @performHIFUMove;
 UConfig.expose.CW.Trigger.Period = 1;

% Create Scan
UConfig.expose.CW.newScan('HIFUScan', UConfig.H_102, 'Plane', 'Segmented');

% Core Scan Properties
UConfig.expose.CW.HIFUScan.FirstElement = 1;
UConfig.expose.CW.HIFUScan.LastElement = 1;
UConfig.expose.CW.HIFUScan.NTimes = 1;
UConfig.expose.CW.HIFUScan.SpeedOfSound = 1480;

% Transmit Properties
% A ten second duration is much longer than waveform memory! Using this
% mode we can excite for HIFU 
UConfig.expose.CW.HIFUScan.Transmit.Duration = 1;
UConfig.expose.CW.HIFUScan.Transmit.Amplitude = 0.8;
UConfig.expose.CW.HIFUScan.Transmit.CentralFrequency = 1.1E6;

% Ramp up and ramp down slowly changes the amplitude from 0 to the max
% amplitude outlined above over a number of waveform cycles. The default
% number is four, but this shows how we can increase ramp up to 6 and
% reduce ramp down to none.
UConfig.expose.CW.HIFUScan.Transmit.RampUpCycles = 6;
UConfig.expose.CW.HIFUScan.Transmit.RampDownCycles = 0;

% No Receive Properties as this is transmit only
UConfig.expose.CW.HIFUScan.Receive.Enabled = false;

% PSU Properties
UConfig.expose.CW.HIFUScan.PSU.Enabled = true;
UConfig.expose.CW.HIFUScan.PSU.Voltages = [-72 -36 36 72];
UConfig.expose.CW.HIFUScan.PSU.Currents = [0.315, 0.315, 0.315, 0.315];

% Calculate Procedure Data
UConfig.expose.calculateData();

% Configure UARP Hardware
UConfig.expose.configureHardware();

%% Run Procedure
UConfig.expose.psuEnable();

UConfig.expose.execute();

UConfig.expose.psuDisable();
