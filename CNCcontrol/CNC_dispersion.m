global CNC

% Set default parameters
CNC.SoftwareLimits.X.Values = [0 0];
CNC.SoftwareLimits.X.Enabled = false;
CNC.SoftwareLimits.Y.Values = [0 0];
CNC.SoftwareLimits.Y.Enabled = false;
CNC.SoftwareLimits.Z.Values = [0 0];
CNC.SoftwareLimits.Z.Enabled = false;
CNC.SoftwareLimits.R.Values = [-180 180]; 
CNC.SoftwareLimits.R.Enabled = true;

CNC_OpenConnection('COM4');
CNC_EnableDrives();

disp('Remove clamps from vertical (Z) axis. Then press any key to continue.')
pause

CNC_Home();
CNC_Status();


CNC_CurrentPosition()
CNC_CommandedPosition()

%% Ask user to fit transducer

disp('Fit Transducer')
pause

%Move x/y

preload = -112;
xStart = 78;
yStart = 90;

CNC_MovePositionLinear(xStart,yStart,preload+10,0,true);

%% Carefull do Z

disp('Traverse Z');
pause

%Always go up first
CNC_MovePositionLinear(xStart,yStart,preload+50,0,true);

CNC_MovePositionLinear(xStart,yStart,preload,0,true);

%% Take measurements

disp('Will begin measure');
pause;

nPoints = 512;
length = 15;
gap = length/nPoints; %in mm
%gap = 0.5;
gap = 0.07;

thisX = xStart;
thisY = yStart;

for i=1:nPoints
    %Take measure here
    pause(1);
    disp('Taking Measurement');
    recording = getWaveform('192.168.0.2',1);
    %Save to disk to free memory
    fname = ['rfpost5' num2str(i) '.mat'];
    save(fname,'recording');
    %Bring Z up first
    CNC_MovePositionLinear(thisX,thisY,preload+10,0,true);
    %Move X
    thisY = yStart - (i*gap);
    CNC_MovePositionLinear(thisX,thisY,preload+10,0,true);
    %Preload
    CNC_MovePositionLinear(thisX,thisY,preload,0,true);
end

CNC_MovePositionLinear(thisX,thisY,preload+50,0,true);



%% Park CNC system

CNC_MovePosition(xStart,yStart,0,0,true);

disp('Apply clamps to vertical (Z) axis. Then press any key to continue.')
pause

CNC_DisableDrives();

CNC_CloseConnection();  