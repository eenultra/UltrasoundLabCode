%% Move system to Park Position and shut down connection
%
% Function Prototype:
%   [] = CNC_Park()
%
% Long Description:
%   This function move the controller to the parking position and closes connection.
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

function [] = CNC_Park()

global CNC;

CNC_MovePosition(0,0,100,0,true);

disp('Apply clamps to vertical (Z) axis. Then press any key to continue.')
pause
 
CNC_DisableDrives();

CNC_CloseConnection();
    
