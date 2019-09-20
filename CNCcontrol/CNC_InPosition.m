%% Open Serial Connection
%
% Function Prototype:
%   [CurrentPosition] = CNC_InPosition()
%
% Long Description:
%   This function will open the specified COM port and configure the
%   terminator characters to char(26) as configured on the CNC system.
%
% Globals Required:
%   CNC
%
% Globals Written:
%   CNC.InPosition
%   
% Parameters:
%   None
%
% Return Values:
%   status : The completion status of the function. Returns: true or false
%

function [InPosition] = CNC_InPosition()

global CNC

CNC_CurrentPosition();
CNC_CommandedPosition();

InPosition = (CNC.CurrentPosition == CNC.CommandedPosition);
CNC.InPosition = InPosition;