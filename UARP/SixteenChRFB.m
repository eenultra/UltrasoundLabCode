%% Initialise UConfig
% This section clears any existing UARP configurations, 
% and creates a new blank UARP configuration with the right simulated hardware for this demo.
UARP.init('UARPII-16');

% Initialise Platform Hardware
% We must first prepare the UARP hardware so we can upload machine data to it later.
UConfig.initialiseHardware();

% Define Logical Transducer
% First we define any transducers that are physically connected to the system. 
% We must give a name, a model of transducer from the library, and optionally a mapping of how the transducer is connected to any UARP systems. 
% If no mapping is given, then the best-fit mapping will be automatically generated.

Olympus_NDT = UConfig.newTransducer('Olymp2MHz', UARP.Transducer.Template.UnfocussedImmersionNDT);

% Connect to the RFB
scale = ULab.Scale.Mettler_ML204T('RFB','COM','COM3');


%% Create Procedure
%Next, we must create a procedure with a name. 
%A procedure is a set of operations which are all uploaded to the UARP at once. 
% Only one procedure can be loaded at any time.

ndtProc = UConfig.newProcedure('ndtProcedure');

ndtProc.NTimes         = 5; % Number of times to repeat whole procedure.
ndtProc.DownloadMode   = 'Disabled'; %How to download receive data back from the UARP. Disabled as transmit only
ndtProc.Trigger.InMode = 'Internal'; %Set up procedure triggering.

%% Create Operation
%Now we must create an operation with a name. Operations define how scans interact with each other. 
% In this case, the scan is sequential, meaning any scans added to it will be executed after one another in the order they were added.
% There are three possible sequencing modes for operations:
% Sequential: Scans executed one after the next in the order they were made - A1, A2, B1, B2.
% Parallel: Scans executed at the same time - A1B1, A2B2. Channels must not overlap.
% Interleaved: Each step of the scans will be executed in a cyclic manner - A1, B1, A2, B2.

ndtOp                = ndtProc.newOperation('NDTOperation', 'Sequential');
ndtOp.Trigger.Period = 10e-3; % Set the trigger period (PRF) for the operation.

%% Create a Scan
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

ndtScan = ndtOp.newScan('ndtScan',XDR323, 'Plane', 'Segmented');

% Core Scan Properties
ndtScan.FirstElement = 1;
ndtScan.LastElement  = 1;
ndtScan.NTimes       = 1;
ndtScan.SpeedOfSound = 1480;

ndtScan.Transmit.Waveform.Duration         = 10;
ndtScan.Transmit.Waveform.Amplitude        = 0.5;
ndtScan.Transmit.Waveform.CentralFrequency = 2E6;

% Ramp up and ramp down slowly changes the amplitude from 0 to the max amplitude outlined above over a number of waveform cycles. 
% The default number is four, but this shows how we can increase ramp up to 6 and reduce ramp down to none.

ndtScan.Transmit.Waveform.RampUpCycles   = 6;
ndtScan.Transmit.Waveform.RampDownCycles = 0;

ndtScan.Receive.Enabled = false;
ndtScan.PSU.Enabled     = true;
ndtScan.PSU.Voltage     = 72;

%% Create worker for RFB

worker = ndtOp.newWorker('RFB','ULab.Worker.ForceMeasure');
worker.Scale = scale;
worker.MeasureTime = ndtScan.Transmit.Waveform.Duration/2;

%% Calculate Procedure Data
% Some property validation takes place whenever a property has a new value set. 
% However, there is more calculation that must be done to turn a scan into machine data the UARP understands.

ndtProc.calculateData();

% Plot Procedure
% It is often a good idea to plot what we have described above to ensure we are going to get what we expect from the hardware.

ndtProc.plot();

%% Configure UARP Hardware
% The hardware of the UARP then needs configuring. 
% We must upload the procedure configuration to UARP devices, disable PSUs, then configure voltage/current settings.

ndtProc.configureHardware();

%% Run Procedure

ndtProc.psuEnable();  % We then enable high-voltage PSUs for all systems used by the procedure.
ndtProc.execute();    % Then we instruct the UARP hardware to actually execute the procedure.
ndtProc.psuDisable(); % Power-supplies will be turned off automatically at the end of the execute function. But we can also do it here to be doubly sure.







