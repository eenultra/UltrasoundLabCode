%% HIFU Scan
% This is a 'golden' test script showing how to perform a HIFU scan. We use
% a special transmit mode that self-loops an HRPWM generated signal so that
% the hardware does not run out of transmit memory. Using this mode, we can
% generate up to half an hour of continuous wave HIFU excitation.

%% Initialise UConfig
% This section clears any existing UARP configurations, and creates a new
% blank UARP configuration with the right simulated hardware for this demo.
UARP.init;

%% Initialise Platform Hardware
UConfig.initialiseHardware();

%% Define Logical Transducer
% First we define any transducers that are physically connected to the
% system. We must give a name, a model of transducer from the library, and
% optionally a mapping of how the transducer is connected to any UARP
% systems. If no mapping is given, then the best-fit mapping will be
% automatically generated.
%
%   - name              A valid MATLAB name for this operation.
%
%   - transducerModel   The model of the transducer in question. Must
%                       relate to a transducer defined in the hardware
%                       library. Can be a string of a library transducer
%                       name or model, or a transducer library object.
%                       
%   - transducerMap     How the transducer is mapped to any UARP systems in
%                       use. If no mapping is given, then the best-fit
%                       mapping will be automatically generated.
%
UConfig.newTransducer('Imasonic10', UConfig.Library.Transducer.IMA_10, '');

%% Create Procedure
% Next, we must create a procedure. A procedure is a set of operations
% which are all uploaded to the UARP at once. Only one procedure can be
% loaded at any time.
%
% Names can be anything as long as it is a valid MATLAB handle
% (i.e. any of    A-Z 0-9 _    starting with a letter).
%
%   - name              A valid MATLAB name for this operation.
%
UConfig.newProcedure('PulseProcedure');

% Number of times to repeat whole procedure.
UConfig.PulseProcedure.NTimes = 10;

% How to download receive data back from the UARP.
UConfig.PulseProcedure.DownloadMode = UARP.Constant.DownloadMode.Disabled;

% Set up procedure triggering.
UConfig.PulseProcedure.Trigger.InMode = 'Internal';
UConfig.PulseProcedure.Trigger.InPolarity = 'RisingEdge';

%% Create Operation
% Now we must create an operation. Operations define how scans interact
% with each other. In this case, the scan is sequential, meaning any scans
% added to it will be executed after one another in the order they were
% added.
%
%   - name              A valid MATLAB name for this operation.
%
%   - variant           Core variant of this operation. Setting this
%                       defines the behaviour of how scans are executed in
%                       this operation.
%                       Choose from: Sequential, Parallel, Interleaved
%
UConfig.PulseProcedure.newOperation('TenCyclePulse', 'Sequential');

%% Create Scan
% A scan is one ultrasound experiment (imaging or TxOnly). This is where the
% majority of the parameters users are concerned with live.
%
% When defining a scan, other than a name, there are three parameters we
% are concerned with. They are as follows:
%
%   - name              A valid MATLAB name for this operation.
%
%   - transducer        A single, or an array of UARP.User.Transducer
%                       objects which the scan is to be performed on.
%
%   - variant           Core variant of this scan. Setting this exposes
%                       different properties of the scan, based on use.
%                       Choose from: Linear, Phased, Plane, Divergent, TxOnly
%
%   - transmitVariant   Transmit variant of this scan. Defines which
%                       properties are exposed for making a transmit
%                       waveform.
%                       Choose from: HRPWM, Arbitrary, Switched
%
UConfig.PulseProcedure.TenCyclePulse.newScan('Scan1', UConfig.Imasonic10, 'TxOnly', 'Arbitrary');

% Core Scan Properties
UConfig.PulseProcedure.TenCyclePulse.Scan1.FirstElement = 1;
UConfig.PulseProcedure.TenCyclePulse.Scan1.LastElement = 1;
UConfig.PulseProcedure.TenCyclePulse.Scan1.NTimes = 1;
UConfig.PulseProcedure.TenCyclePulse.Scan1.SpeedOfSound = 1480;
UConfig.PulseProcedure.TenCyclePulse.Scan1.ImageDepth = 0.01;


% Transmit Properties
UConfig.PulseProcedure.TenCyclePulse.Scan1.Transmit.CentralFrequency = 1.7e6;
UConfig.PulseProcedure.TenCyclePulse.Scan1.Transmit.Duration = 5.8824e-06; %s
UConfig.PulseProcedure.TenCyclePulse.Scan1.Transmit.Amplitude = 0.80;
UConfig.PulseProcedure.TenCyclePulse.Scan1.Transmit.Envelope = 'Hann';
UConfig.PulseProcedure.TenCyclePulse.Scan1.Transmit.EnvelopeParameter = 0.8;


% No Receive Properties as this is transmit only

% PSU Properties
UConfig.PulseProcedure.TenCyclePulse.Scan1.PSU.Enabled = true;
UConfig.PulseProcedure.TenCyclePulse.Scan1.PSU.Voltages = [-72 -36 36 72];
UConfig.PulseProcedure.TenCyclePulse.Scan1.PSU.Currents = [0.315 0.315 0.315 0.315];

%% Calculate Procedure Data
% Some property validation takes place whenever a property has a new value
% set. However, there is much more that needs to be done to turn a scan
% into experiment data the UARP understands. That is achieved as follows.
%
% As was descirbed earlier, a procedure is the single unit of information
% that can be uploaded to the UARP at once. Hence, procedure calls the next
% functions.
UConfig.PulseProcedure.calculateData();


%% Configure UARP Hardware
% The hardware of the UARP then needs configuring. We must uploads the
% procedure configuration to UARP devices, disable PSUs, then configure
% voltage/current settings.
UConfig.PulseProcedure.configureHardware();

%% Run Procedure
% We then enable high-voltage PSUs for all systems used by the procedure.
UConfig.PulseProcedure.psuEnable();

% This function actually executes the procedure on the UARP.
UConfig.PulseProcedure.execute();

% Power-supplies will be turned off automatically at the end of the execute
% function. But we can also do it here to be doubly sure.
UConfig.PulseProcedure.psuDisable();
