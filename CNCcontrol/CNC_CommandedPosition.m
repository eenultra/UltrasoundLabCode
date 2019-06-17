%% Open Serial Connection
%
% Function Prototype:
%   [CurrentPosition] = CNC_CommandedPosition()
%
% Long Description:
%   This function will open the specified COM port and configure the
%   terminator characters to char(26) as configured on the CNC system.
%
% Globals Required:
%   CNC
%
% Globals Written:
%   CNC.CommandedPosition
%   
% Parameters:
%   None
%
% Return Values:
%   CommandedPosition : The commanded position of the controller.
%

function [CommandedPosition] = CNC_CommandedPosition()

global CNC

CNC_Flush();

fprintf(CNC.Config.Serial,':!tpc:');

% Read response and drop terminators
str = fgetl(CNC.Config.Serial);

% Convert response to array
[C,~] = strsplit(str,',','CollapseDelimiters',true);

CommandedPosition(1) = str2double(cell2mat(C(4))); % X
CommandedPosition(2) = str2double(cell2mat(C(2))); % Y 
CommandedPosition(3) = str2double(cell2mat(C(1))); % Z
CommandedPosition(4) = str2double(cell2mat(C(3))); % R 

CNC.CommandedPosition = CommandedPosition;
