%% Initialise UConfig
% This section clears any existing UARP configurations, 
% and creates a new blank UARP configuration with the right simulated hardware for this demo.
UARP.init('UARPIIa_128_HIFU');

% Initialise Platform Hardware
% We must first prepare the UARP hardware so we can upload machine data to it later.
UConfig.initialiseHardware();

% Create External Power Supply
% Optionally connect to an external PSU for HIFU

psu = ULab.PSU.RohdeSch_NGP8xx('psu', 'visa', ULeeds.Lab.Address.PSU_5601_4007k03_100803, ULab.PSU.Constant.ChannelMapping.bipolarStacked(4));
UConfig.Platform.Systems(1).setExternalPSU(psu);

% Define Logical Transducer
% First we define any transducers that are physically connected to the system. 
% We must give a name, a model of transducer from the library, and optionally a mapping of how the transducer is connected to any UARP systems. 
% If no mapping is given, then the best-fit mapping will be automatically generated.

h102XDR = UConfig.newTransducer('H102_68', UARP.Transducer.SonicConcepts_H_102);

%% Create Procedure
%Next, we must create a procedure with a name. 
%A procedure is a set of operations which are all uploaded to the UARP at once. 
% Only one procedure can be loaded at any time.

hifuProc = UConfig.newProcedure('HIFUProcedure');

hifuProc.NTimes         = 5; % Number of times to repeat whole procedure.
hifuProc.DownloadMode   = 'Disabled'; %How to download receive data back from the UARP. Disabled as transmit only
hifuProc.Trigger.InMode = 'Internal'; %Set up procedure triggering.

%% Create Operation
%Now we must create an operation with a name. Operations define how scans interact with each other. 
% In this case, the scan is sequential, meaning any scans added to it will be executed after one another in the order they were added.
% There are three possible sequencing modes for operations:
% Sequential: Scans executed one after the next in the order they were made - A1, A2, B1, B2.
% Parallel: Scans executed at the same time - A1B1, A2B2. Channels must not overlap.
% Interleaved: Each step of the scans will be executed in a cyclic manner - A1, B1, A2, B2.

hifuOp                = hifuProc.newOperation('HIFUOperation', 'Sequential');
hifuOp.Trigger.Period = 10e-3; % Set the trigger period (PRF) for the operation.

%% Create a HIFU Scan
% A scan is one ultrasound experiment (imaging or therapy). This is where the majority of the parameters users are concerned with live.
% We must define a scan with a name, and an array of any transducers (created above) that are used in it.

% There are four types of scan that we support, they describe how the transducer will be used:
%     Plane: Uses all active elements at once, with no focussing.
%     Linear: Uses sub-aperture to cycle through transducer regions.
%     Phased: Allows for focussed beams using focal length.
%     Divergent: Allows for divergent beams using focal length.

% We must also define how we are making our transmit waveforms:
%     None: No transmit waveforms used (for receive only scans).
%     HRPWM: Use HRPWM generator function to create a waveform from parameters.
%     Segmented: Create very long looped waveforms using segments (primarily for HIFU).
%     MultiTrigger: Long waveforms split across multiple triggers.
%     Arbitrary: Transform arbitrary analog voltage waveform into switched waveform using HRPWM.
%     Switched: Provide a switched waveform that is ready for direct transmission.

hifuScan = hifuOp.newScan('HIFUScan', h102XDR, 'Plane', 'Segmented');

% Core Scan Properties
hifuScan.FirstElement = 1;
hifuScan.LastElement  = 1;
hifuScan.NTimes       = 1;
hifuScan.SpeedOfSound = 1480;

hifuScan.Transmit.Waveform.Duration         = 10E-3;
hifuScan.Transmit.Waveform.Amplitude        = 0.1;
hifuScan.Transmit.Waveform.CentralFrequency = 1.1E6;

% Ramp up and ramp down slowly changes the amplitude from 0 to the max amplitude outlined above over a number of waveform cycles. 
% The default number is four, but this shows how we can increase ramp up to 6 and reduce ramp down to none.

hifuScan.Transmit.Waveform.RampUpCycles   = 6;
hifuScan.Transmit.Waveform.RampDownCycles = 0;

hifuScan.Receive.Enabled = false;
hifuScan.PSU.Enabled     = true;
hifuScan.PSU.Voltage     = 72;

%% Calculate Procedure Data
% Some property validation takes place whenever a property has a new value set. 
% However, there is more calculation that must be done to turn a scan into machine data the UARP understands.

hifuProc.calculateData();

% Plot Procedure
% It is often a good idea to plot what we have described above to ensure we are going to get what we expect from the hardware.

hifuProc.plot();

%% Configure UARP Hardware
% The hardware of the UARP then needs configuring. 
% We must upload the procedure configuration to UARP devices, disable PSUs, then configure voltage/current settings.

hifuProc.configureHardware();

%% Run Procedure

hifuProc.psuEnable();  % We then enable high-voltage PSUs for all systems used by the procedure.
hifuProc.execute();    % Then we instruct the UARP hardware to actually execute the procedure.
hifuProc.psuDisable(); % Power-supplies will be turned off automatically at the end of the execute function. But we can also do it here to be doubly sure.







