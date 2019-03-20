% Using Thorlabs APT protocol, open connection to the three Thorlab linear
% stages (LS3).
% sets global for each stage (with corresponding figure) to be controlled
% independently.

%James McLaughlan
%University of Leeds
%Feb 2019

%%
global xLS yLS zLS; % make RT a global variable so it can be used outside the main function. Useful when you do event handling and sequential move
  
disp('Connecting and initialising stages, please wait');
%% Create Matlab Figure Container
xfpos    = get(0,'DefaultFigurePosition'); % figure default position
xfpos(1) = xfpos(1) - xfpos(1)+20;
xfpos(3) = 650; % figure window size;Width
xfpos(4) = 450; % Height

yfpos    = xfpos;
yfpos(1) = xfpos(1) + (0.5*xfpos(3));

zfpos    = xfpos;
zfpos(1) = xfpos(1) + (xfpos(3));
 
xf = figure('Position', xfpos,...
           'Menu','None',...
           'Name','X axis');
       
yf = figure('Position', yfpos,...
           'Menu','None',...
           'Name','Y axis');

zf = figure('Position', zfpos,...
           'Menu','None',...
           'Name','Z axis');
       
%% Create ActiveX Controller
xLS = actxcontrol('MGMOTOR.MGMotorCtrl.1',[20 20 600 400], xf);pause(1);
yLS = actxcontrol('MGMOTOR.MGMotorCtrl.1',[20 20 600 400], yf);pause(1);
zLS = actxcontrol('MGMOTOR.MGMotorCtrl.1',[20 20 600 400], zf);pause(1);

%% Initialize
%S/N are for the 3 cubes used with the linear  %compact linear% stages

% Start Control
xLS.StartCtrl;
% Set the Serial Number
xSN = 27501235; %27252508;% put in the serial number of the hardware
set(xLS,'HWSerialNum', xSN);
% Indentify the device
xLS.Identify; 
pause(5); % waiting for the GUI to load up;

% Start Control
yLS.StartCtrl;
% Set the Serial Number
ySN = 27501294; % 27252617;%put in the serial number of the hardware
set(yLS,'HWSerialNum', ySN);
% Indentify the device
yLS.Identify; 
pause(5); % waiting for the GUI to load up;

% Start Control
zLS.StartCtrl;
% Set the Serial Number
zSN = 27501290; % 27504090;%put in the serial number of the hardware
set(zLS,'HWSerialNum', zSN);
% Indentify the device
zLS.Identify; 
pause(5); % waiting for the GUI to load up;

%% Controlling the Hardware

userStr = input('Do you want to home stages y/n? ','s');
    if userStr == 'y'
        disp('Homing, please wait');
        xLS.MoveHome(0,0);% Home the stage. First 0 is the channel ID (channel 1), second 0 is to move immediately
        yLS.MoveHome(0,0);
        zLS.MoveHome(0,0);
    end

%% Event Handling
xLS.registerevent({'MoveComplete' 'MoveCompleteHandler'});
yLS.registerevent({'MoveComplete' 'MoveCompleteHandler'});
zLS.registerevent({'MoveComplete' 'MoveCompleteHandler'});
%% Sending Moving Commands
timeout = 10; % timeout for waiting the move to be completed
%RT.MoveJog(0,1); % Jog
 
% Move a absolute distance
%RT.SetAbsMovePos(0,7);
%RT.MoveAbsolute(0,1==0);
 
t1 = clock; % current time
while(etime(clock,t1)<timeout) 
% wait while the motor is active; timeout to avoid dead loo
    sX = xLS.GetStatusBits_Bits(0);
    sY = yLS.GetStatusBits_Bits(0);
    sZ = zLS.GetStatusBits_Bits(0);
    if (IsMoving(sX) == 0)
      pause(2); % pause 2 seconds;
      xLS.MoveHome(0,0);
      disp('Home Started!');
    end
    if (IsMoving(sY) == 0)
      pause(2); % pause 2 seconds;
      yLS.MoveHome(0,0);
      disp('Home Started!');
    end
    if (IsMoving(sZ) == 0)
      pause(2); % pause 2 seconds;
      zLS.MoveHome(0,0);
      disp('Home Started!');
    end
    break
end

disp('Finished');

