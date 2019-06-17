%% Open connection and guide homing of the axis
%
% Function Prototype:
%   [] = CNC_Start()
%
% Long Description:
%   This function establishes a serial connection and guide the system trough homing.
%
% Globals Required:
%   CNC
%
% Globals Written:
%   CNC
%   
% Parameters:
%  
%
% Return Values:
%   
%

function [] = CNC_Start()

global CNC;

CNC_OpenConnection('COM4');
CNC_EnableDrives();

disp('Remove clamps from vertical (Z) axis. Then press any key to continue.')
pause

CNC_Home();
CNC_Status();

CNC_CurrentPosition()
CNC_CommandedPosition()

