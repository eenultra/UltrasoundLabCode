%% Configure 6K4 controller
%
% Function Prototype:
%   [status] = CNC_ConfigureController()
%
% Long Description:
%   This function will open the specified COM port and configure the
%   terminator characters to char(26) as configured on the CNC system.
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

function [status] = CNC_ConfigureController()

global CNC

% Disable serial port echo on controller
fprintf(CNC.Config.Serial,':ECHO0:');

% Set end of line terminator character to char(13)
fprintf(CNC.Config.Serial,':EOL13:');

% Set end of transmission terminator character to char(26)
fprintf(CNC.Config.Serial,':EOT26:');

% Set all velocity parameters to '1'
fprintf(CNC.Config.Serial,':@v1:');

% Set distance scaling parameters // Z Y R X
fprintf(CNC.Config.Serial,':SCLD800,200,1333,667:');

% Set velocity scaling parameters
fprintf(CNC.Config.Serial,':SCLV800,200,1333,667:');

% Set acceleration scaling parameters
fprintf(CNC.Config.Serial,':SCLA800,200,1333,667:');

% Enable positive and negative hardware limits 
fprintf(CNC.Config.Serial,':LH3,3,0,3:');

% Set positive and negative hardware limit deaceleration 
fprintf(CNC.Config.Serial,':@LHAD25: :@LHADA12.5:');

% Set Hardware Limit Input Active Level
fprintf(CNC.Config.Serial,':LIMLVL000000000000:');
%fprintf(CNC.Config.Serial,':LIMLVL111111111111:');

% Set positive and negative software limits Z Y R X	
soft_limit_string = [':LS' num2str(3*CNC.SoftwareLimits.Z.Enabled) ',' ...
                           num2str(3*CNC.SoftwareLimits.Y.Enabled) ',' ...
                           num2str(3*CNC.SoftwareLimits.R.Enabled) ',' ...
                           num2str(3*CNC.SoftwareLimits.X.Enabled) ':' ...
                  ':LSPOS' num2str(max(CNC.SoftwareLimits.Z.Values)) ',' ...
                           num2str(max(CNC.SoftwareLimits.Y.Values)) ',' ...
                           num2str(max(CNC.SoftwareLimits.R.Values)) ',' ...
                           num2str(max(CNC.SoftwareLimits.X.Values)) ':' ...
                  ':LSNEG' num2str(min(CNC.SoftwareLimits.Z.Values)) ',' ...
                           num2str(min(CNC.SoftwareLimits.Y.Values)) ',' ...
                           num2str(min(CNC.SoftwareLimits.R.Values)) ',' ...
                           num2str(min(CNC.SoftwareLimits.X.Values)) ':'];
                          
%fprintf(CNC.Config.Serial,':LS0,0,3,0: :LSPOS0,0,180,0: :LSNEG0,0,-180,0:');
fprintf(CNC.Config.Serial,soft_limit_string);
% Set positive and negative software limit deaceleration 
fprintf(CNC.Config.Serial,':@LSAD25: :@LSADA12.5:');

% Set/Enable controller logic output
% Output 1 on controller flags when any axis is moving
% Output 2 on controller flags when stationary
fprintf(CNC.Config.Serial,':OUTLVL01: :OUTFNC1-B: :OUTFNC2-B:');

% Set absolute positioning mode
fprintf(CNC.Config.Serial,':MA1111::MC0000:');

% Set acceleration and average acceraration
fprintf(CNC.Config.Serial,':A15,15,15,15::AA7.5,7.5,7.5,7.5:');
% Set de-acceleration and average de-acceraration
fprintf(CNC.Config.Serial,':AD15,15,15,15: :ADA7.5,7.5,7.5,7.5:');

% Set path acceleration and average acceraration
fprintf(CNC.Config.Serial,':PA15,15,15,15::PAA7.5,7.5,7.5,7.5:');
% Set path de-acceleration and average de-acceraration
fprintf(CNC.Config.Serial,':PAD15,15,15,15: :PADA7.5,7.5,7.5,7.5:');

% Set velocity
fprintf(CNC.Config.Serial,':V25,25,25,25:');

% Set path velocity
fprintf(CNC.Config.Serial,':PV25,25,25,25:');

% Set direction polarity
fprintf(CNC.Config.Serial,':CMDDIR1001:');

status = true;

