%% SigGen Control
% This script shows how we can control the SigGen for HIFU whilst imaging
% using the UARPII.

%% Initialise UConfig
% This section clears any existing UARP configurations, and creates a new
% blank UARP configuration with the right simulated hardware for this demo.
UARP.init('UARPII');

%% Initialise Platform Hardware
UConfig.initialiseHardware();

%% CONFIGURE ROBOT ARM HERE


%% CONFIGURE TRANSDUCERS, PROCEDURE, OPERATION, SCAN

% Then add to your operation
UConfig.<procedure>.<operation>.NTimes = 10;
UConfig.<procedure>.<operation>.ExecuteCallback = @RobotArm.performSTMove;

%% Calculate Procedure Data
UConfig.Procedure1.calculateData();

%% Configure UARP Hardware
UConfig.Procedure1.configureHardware();

%% Run Procedure
UConfig.Procedure1.psuEnable();
UConfig.Procedure1.execute();
UConfig.Procedure1.psuDisable();
