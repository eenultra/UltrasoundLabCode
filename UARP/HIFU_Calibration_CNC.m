%% Initialise UConfig
% This section clears any existing UARP configurations, 
% and creates a new blank UARP configuration with the right simulated hardware for this demo.
UARP.init('UARPIIa_128_HIFU');

% Load HIFU IV Calibration data
load("calibCoeffs.mat")

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

h102XDR = UConfig.newTransducer('H102_65', UARP.Transducer.SonicConcepts_H_102);

%Second, an IV measuring 'transducer'.
ivMeasureSensor = UConfig.newTransducer(...
    'IVMeasurementSensor', UARP.Transducer.UniLeeds_IVPowerSensor);

% Create Procedure
%Next, we must create a procedure with a name. 
proc                = UConfig.newProcedure('HIFUProcedure');
proc.DownloadMode   = 'AtEndOfProcedure'; %How to download receive data back from the UARP. Disabled as transmit only
proc.Trigger.InMode = 'Internal'; %Set up procedure triggering.
proc.Trigger.Out1Mode = 'Line';

% Create Operation
%Now we must create an operation with a name. Operations define how scans interact with each other. 
% In this case, the scan is sequential, meaning any scans added to it will be executed after one another in the order they were added.
% There are three possible sequencing modes for operations:
% Sequential: Scans executed one after the next in the order they were made - A1, A2, B1, B2.
% Parallel: Scans executed at the same time - A1B1, A2B2. Channels must not overlap.
% Interleaved: Each step of the scans will be executed in a cyclic manner - A1, B1, A2, B2.
op                = proc.newOperation('HIFUOperation', 'Parallel');
op.Trigger.Period = 10e-3; % Set the trigger period (PRF) for the operation.
%hifuOp.Trigger.EndDelay = 0;  % Wait time in seconds after HIFU finishes. RFB measurement will be taken after this time.

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

hifuScan = op.newScan('HIFUScan', h102XDR, 'Plane', 'HRPWM');

% Core Scan Properties
hifuScan.FirstElement = 1;
hifuScan.LastElement  = 1;
hifuScan.NTimes       = 1;
hifuScan.SpeedOfSound = 1480;

hifuScan.Transmit.Waveform.Duration         = 10e-6;
hifuScan.Transmit.Waveform.Amplitude        = 1;
hifuScan.Transmit.Waveform.CentralFrequency = 1.1E6;

% add windowing here??

idx = find(fftPoints > hifuScan.Transmit.Waveform.CentralFrequency,1,'first');

% Ramp up and ramp down slowly changes the amplitude from 0 to the max amplitude outlined above over a number of waveform cycles. 
% The default number is four, but this shows how we can increase ramp up to 6 and reduce ramp down to none.
hifuScan.Receive.Enabled = false;
hifuScan.PSU.Enabled     = true;
hifuScan.PSU.Voltage     = 100;

% Create IV-Measurement Scan

measureScan = op.newScan('IVMeasureScan', ivMeasureSensor, 'Plane', 'HRPWM');
measureScan.FirstElement = 1;
measureScan.LastElement = 2;
measureScan.NTimes = 10;
measureScan.SpeedOfSound = 1480;

measureScan.Transmit.Enabled = false; %No Transmit Properties as this is transmit only

measureScan.Receive.ImageDepth = 0.3;
measureScan.Receive.SteeringAngle = 0;
measureScan.Receive.Filter = {measureScan.Receive.MasterReceiver.getInterpFilter(5e6)};
measureScan.Receive.Decimation = 'FullRate';
measureScan.Receive.CopyToMatlab = 'RawData';
measureScan.Receive.CopyDataType = 'double';
measureScan.Receive.AFE.PGAGain = 0;

% Configure Plotting
% Select the pre-made a-mode time and frequency domain DSP chain.

dsp = measureScan.Receive.newDSPChain('MeasureIV','UARP.Demo.Experiment.IVMeasure.IVProcessChain', ...
    'PlotCanvas', UBase.GUI.Panel.Subplot());

% Decimate the IV data, auto-detecting offset to remove zero stuffing.
dsp.Decimate.DecimationFactor      = 5;
dsp.Decimate.DecimationFirstSample = 0;
dsp.Filter.StartFreq = hifuScan.Transducers(1).CentralFrequency * 0.5;
dsp.Filter.StopFreq = hifuScan.Transducers(1).CentralFrequency * 3.5;

% Configure voltage parameters
vDsp = dsp.VoltageDisplay;
vDsp.Normalise.Level = vfitcoeff(idx) *(4096/640) * 10^(measureScan.Receive.AFE.PGAGain/20); % need calbCoeffs file for V/I correction based on Tom's thesis work.
vDsp.PlotTime.Description = 'HIFU Voltage';
vDsp.PlotTime.XLimits = [0 50e-6];
vDsp.PlotTime.YLimits = [-150 150];
vDsp.PlotFrequency.YLimits = [vDsp.FFT.MinimumAmplitude 10];

% Configure current parameters
cDsp = dsp.CurrentDisplay;
cDsp.Normalise.Level = ifitcoeff(idx) *(4096/12.8) * 10^(measureScan.Receive.AFE.PGAGain/20);% need calbCoeffs file for V/I correction based on Tom's thesis work.
cDsp.PlotTime.Description = 'HIFU Current';
cDsp.PlotTime.XLimits = [0 50e-6];
cDsp.PlotTime.YLimits = [-4 4];
cDsp.PlotFrequency.YLimits = [cDsp.FFT.MinimumAmplitude 10];%% Create worker for RFB

%% Create and Initialise CNC

% Connect to cnc
cnc = ULab.CNC.Parker_Compumotor6k4('CNC','tcp4','192.168.42.109:5025');

% Home CNC
cnc.start();

%% Configure CNC

% Add CNC movement worker.
cncWorker = op.newWorker('MoveCNC',ULab.Worker.CNC);
cncWorker.CNCObject = cnc;

% Set n*3 array of XYZ positions you want to move to.
cncWorker.Positions = [0 0 0; 0.01 0 0];

% Run procedure once for each position.
proc.NTimes = cncWorker.getNRuns();

%% Set up Scope

% Create scope object.
scope = ULab.Scope.Keysight('Scope', 'VISA', ULeeds.Lab.Address.Scope_MY54240137);

% Configure the scope for this many segmented memory triggers.
op.NTimes = 16;

scopeWorker = op.newWorker('DownloadScope', ULab.Worker.Scope);
scopeWorker.ScopeObject = scope;
scopeWorker.SaveFileNames = cncWorker.getPositionStrings();

%% Calculate and Configure.
proc.calculateData();
proc.configureHardware();

%% Run Procedure
experimentTimestamp = UBase.Tools.Format.iso8061str([], 'f');
scopeWorker.SaveDirectory = fullfile('D:', 'Temp', 'Hydrophone', experimentTimestamp);
mkdir(scopeWorker.SaveDirectory);

proc.psuEnable();
proc.execute('Export', fullfile(scopeWorker.SaveDirectory, 'uarp.h5'));
proc.psuDisable();
