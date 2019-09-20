%% Close Serial Connection
%
% Function Prototype:
%   [status] = CNC_OpenConnection(ComPortString)
%
% Long Description:
%   This function will open the specified COM port and configure the
%   terminator characters to char(26) as configured on the CNC system.
%
% Globals Required:
%   CNC
%
% Globals Written:
%   CNC.Config.Serial
%   CNC.Config.Serial.Terminator
%   
% Parameters:
%   ComPortString : String of COM port e.g. 'COM3'
%
% Return Values:
%   status : The completion status of the function. Returns: true or false
%

function [status] = CNC_CloseConnection()

global CNC

try
    % Close Serial Port Object
    fclose(CNC.Config.Serial);

    % Delete Serial Port Object
    CNC.Config = rmfield(CNC.Config,'Serial');
    status = true;
    
catch 0;
    error('Closing COM port failed.')
    status = false;
end

%% Close Serial Connection






