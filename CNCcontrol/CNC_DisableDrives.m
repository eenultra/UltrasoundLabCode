%% Configure 6K4 controller
%
% Function Prototype:
%   [status] = CNC_DisableDrives()
%
% Long Description:
%   Disable/De-energise all drives on CNC system.
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

function [status] = CNC_DisableDrives()

global CNC

% Enable drives
fprintf(CNC.Config.Serial,':DRIVE0000:');

status = true;