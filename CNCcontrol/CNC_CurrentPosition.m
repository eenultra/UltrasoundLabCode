%% Open Serial Connection
%
% Function Prototype:
%   [CurrentPosition] = CNC_CurrentPosition()
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

function [CurrentPosition] = CNC_CurrentPosition()

global CNC

CNC_Flush();

fprintf(CNC.Config.Serial,':!tpe:');

% Read response and drop terminators
str = fgetl(CNC.Config.Serial);

% Convert response to array
[C,~] = strsplit(str,',','CollapseDelimiters',true);

CurrentPosition(1) = str2double(cell2mat(C(4))); % X
CurrentPosition(2) = str2double(cell2mat(C(2))); % Y 
CurrentPosition(3) = str2double(cell2mat(C(1))); % Z
CurrentPosition(4) = str2double(cell2mat(C(3))); % R 

CNC.CurrentPosition = CurrentPosition;
