clear; close all; clc;
global RT; % make RT a global variable so it can be used outside the main
          % function. Useful when you do event handling and sequential           move
%% Create Matlab Figure Container
fpos    = get(0,'DefaultFigurePosition'); % figure default position
fpos(3) = 650; % figure window size;Width
fpos(4) = 450; % Height
 
f = figure('Position', fpos,...
           'Menu','None',...
           'Name','APT GUI');
%% Create ActiveX Controller
RT = actxcontrol('MGMOTOR.MGMotorCtrl.1',[20 20 600 400], f);
 
%% Initialize
% Start Control
RT.StartCtrl;
 
% Set the Serial Number
SN = 27501235; % put in the serial number of the hardware
set(RT,'HWSerialNum', SN);
 
% Indentify the device
RT.Identify;
 
pause(5); % waiting for the GUI to load up;
%% Controlling the Hardware
%RT.MoveHome(0,0); % Home the stage. First 0 is the channel ID (channel 1)
                 % second 0 is to move immediately
%% Event Handling
RT.registerevent({'MoveComplete' 'MoveCompleteHandler'});
 
%% Sending Moving Commands
timeout = 10; % timeout for waiting the move to be completed
%RT.MoveJog(0,1); % Jog
 
% Move a absolute distance
RT.SetAbsMovePos(0,7);
RT.MoveAbsolute(0,1==0);
 
t1 = clock; % current time
while(etime(clock,t1)<timeout) 
% wait while the motor is active; timeout to avoid dead loop
    s = RT.GetStatusBits_Bits(0);
    if (IsMoving(s) == 0)
      pause(2); % pause 2 seconds;
      RT.MoveHome(0,0);
      disp('Home Started!');
      break;
    end
end
