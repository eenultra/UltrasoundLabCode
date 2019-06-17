%% Flush Serial Connection Input
%
% Function Prototype:
%   [status] = CNC_Flush()
%
% Long Description:
%   This function will flush the input buffer of the specified COM port.
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

function [status] = CNC_Flush()

global CNC

while( CNC.Config.Serial.BytesAvailable )
    CNC.Config.Serial.BytesAvailable
    fgetl(CNC.Config.Serial);
end

status = true;
