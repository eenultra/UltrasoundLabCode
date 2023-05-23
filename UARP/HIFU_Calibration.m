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

% Connect to the RFB
scale = ULab.Scale.Mettler_ML204T('RFB','COM','COM4');

%Second, an IV measuring 'transducer'.
ivMeasureSensor = UConfig.newTransducer(...
    'IVMeasurementSensor', UARP.Transducer.UniLeeds_IVPowerSensor);

% this assumes single trigger or segmented mode
scope = ULab.Scope.Keysight('Scope', 'visa', ULeeds.Lab.Address.Scope_MY54240137);

% Connect to the RFWattMeter
wattMeter = ULab.Meter.SonicConcepts_RfWattMeter23B('RFWattMeter','COM','COM5');

% Create Procedure
%Next, we must create a procedure with a name. 
%A procedure is a set of operations which are all uploaded to the UARP at once. 
% Only one procedure can be loaded at any time.

hifuProc                = UConfig.newProcedure('HIFUProcedure');
hifuProc.NTimes         = 5;          % Number of times to repeat whole procedure.
hifuProc.DownloadMode   = 'AtEndOfProcedure'; %How to download receive data back from the UARP. Disabled as transmit only
hifuProc.Trigger.InMode = 'Internal'; %Set up procedure triggering.

% Create Operation
%Now we must create an operation with a name. Operations define how scans interact with each other. 
% In this case, the scan is sequential, meaning any scans added to it will be executed after one another in the order they were added.
% There are three possible sequencing modes for operations:
% Sequential: Scans executed one after the next in the order they were made - A1, A2, B1, B2.
% Parallel: Scans executed at the same time - A1B1, A2B2. Channels must not overlap.
% Interleaved: Each step of the scans will be executed in a cyclic manner - A1, B1, A2, B2.

hifuOp                = hifuProc.newOperation('HIFUOperation', 'Parallel');
hifuOp.NTimes         = 1;
hifuOp.Trigger.Period = 1e-3; % Set the trigger period (PRF) for the operation.
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

hifuScan = hifuOp.newScan('HIFUScan', h102XDR, 'Plane', 'MultiTrigger');

% Core Scan Properties
hifuScan.FirstElement = 1;
hifuScan.LastElement  = 1;
hifuScan.NTimes       = 1;
hifuScan.SpeedOfSound = 1480;

hifuScan.Transmit.Waveform.Duration         = 4;
hifuScan.Transmit.Waveform.Amplitude        = 1;
hifuScan.Transmit.Waveform.CentralFrequency = 1.1E6;

idx = find(fftPoints > hifuScan.Transmit.Waveform.CentralFrequency,1,'first');

% Ramp up and ramp down slowly changes the amplitude from 0 to the max amplitude outlined above over a number of waveform cycles. 
% The default number is four, but this shows how we can increase ramp up to 6 and reduce ramp down to none.

hifuScan.Transmit.Waveform.RampUpCycles   = 6;
hifuScan.Transmit.Waveform.RampDownCycles = 0;

hifuScan.Receive.Enabled = false;
hifuScan.PSU.Enabled     = true;
hifuScan.PSU.Voltage     = 100;

% Create IV-Measurement Scan

measureScan = hifuOp.newScan('IVMeasureScan', ivMeasureSensor, 'Plane', 'HRPWM');
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

%
workerRFB = hifuOp.newWorker('RFB','ULab.Worker.ForceMeasure');
workerRFB.Scale = scale;
workerRFB.MeasureTime = hifuScan.Transmit.Waveform.Duration/2;

workerWatt = hifuOp.newWorker('RFWattMeter','ULab.Worker.Meter');
workerWatt.MeterObject = wattMeter;
workerWatt.MeasureTime = hifuScan.Transmit.Waveform.Duration/2;

% Calculate Procedure Data
% Some property validation takes place whenever a property has a new value set. 
% However, there is more calculation that must be done to turn a scan into machine data the UARP understands.

hifuProc.calculateData();

% Plot Procedure
% It is often a good idea to plot what we have described above to ensure we are going to get what we expect from the hardware.

% hifuProc.plot();

% Configure UARP Hardware
% The hardware of the UARP then needs configuring. 
% We must upload the procedure configuration to UARP devices, disable PSUs, then configure voltage/current settings.

hifuProc.configureHardware();

% Run Procedure
fileName =['A' num2str(hifuScan.Transmit.Waveform.Amplitude*100) 'pc_Fr' num2str(hifuScan.Transmit.Waveform.CentralFrequency/1e3) 'kHz'];

hifuProc.psuEnable();  % We then enable high-voltage PSUs for all systems used by the procedure.
scope.trigger('run');
hifuProc.execute();    % Then we instruct the UARP hardware to actually execute the procedure.
hifuProc.psuDisable(); % Power-supplies will be turned off automatically at the end of the execute function. But we can also do it here to be doubly sure.

scopeData = scope.downloadData('Segments', 'all');
scopeData.save(['220818_RFB_scope_' fileName]);
save(['220818_RFB_' fileName '.mat'],'hifuOp','hifuProc','ivMeasureSensor','measureScan','UConfig','workerWatt','workerRFB');
