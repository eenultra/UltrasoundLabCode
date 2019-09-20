%% Configure 6K4 controller
%
% Function Prototype:
%   [status] = CNC_EnableDrives()
%
% Long Description:
%   Enable/Energise all drives on CNC system.
%
% Globals Required:
%   CNC
%
% Globals Written:
%   None
%   
% Parameters:
%   None
%
% Return Values:
%   status : The completion status of the function. Returns: true or false
%

function [status] = CNC_EnableDrives()

global CNC

CNC_Status();
retry = 0;
while(retry<3)
    if ( CNC.Enabled )
        % Enable drives
        fprintf(CNC.Config.Serial,':DRIVE1111:');
        disp('CNC Drives enabled.')
        disp('Remove clamps from vertical (Z) axis. Then press any key to continue.')
        pause
        status = true;
        retry=100;
    else
        disp('CNC system not enabled. Check system. Release any pressed emergency stop buttons and then press reset on controller door.');
        disp('Press any key to retry.');
        status = false;
        retry = retry+1;
        pause
    end
end
if retry==3
    error('CNC system not enabled. Check system. Release any pressed emergency stop buttons and then press reset on controller door.');
end

CNC_Status();