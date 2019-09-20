%% Open Serial Connection
%
% Function Prototype:
%   [CurrentPosition] = CNC_MovePosition(D1,D2,D3,D4,block)
%
% Long Description:
%   This function move the controller to the requested position.
%
% Globals Required:
%   CNC
%
% Globals Written:
%   CNC.CommandedPosition
%   
% Parameters:
%   D1,D2,D3,D4 : Postion of requested axis positions.
%   block       : Blocking or unblocking move
%
% Return Values:
%   status : The completion status of the function. Returns: true or false
%

function [status] = CNC_Jog()

global CNC
direction_char = '0';
while ( direction_char ~= 's' )
    
    commanded_position = CNC_CommandedPosition();
    direction_char = input('Move Direction [Xx Yy Zz s] : ','s');
    direction_char = direction_char(1);
    
    if(direction_char == 'X')
        commanded_position = commanded_position + 0.25*[ 1 0 0 0 ];
    elseif(direction_char == 'x')
        commanded_position = commanded_position - 0.25*[ 1 0 0 0 ];
    elseif(direction_char == 'Y')
        commanded_position = commanded_position + 0.25*[ 0 1 0 0 ];
    elseif(direction_char == 'y')
        commanded_position = commanded_position - 0.25*[ 0 1 0 0 ];
    elseif(direction_char == 'Z')
        commanded_position = commanded_position + 0.25*[ 0 0 1 0 ];
    elseif(direction_char == 'z')
        commanded_position = commanded_position - 0.25*[ 0 0 1 0 ];
    else
        return;
    end
    [status] = CNC_MovePositionLinear(commanded_position(1),commanded_position(2),commanded_position(3),commanded_position(4),1);
    disp(['Current Position: ' num2str(CNC_CurrentPosition()) ])
end


    
