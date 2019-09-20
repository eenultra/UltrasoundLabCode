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

function [status] = CNC_MovePosition(X,Y,Z,R,block)

global CNC

% Set destination position // Z Y R X	
pos_str = [':!D' num2str(Z,3) ',' num2str(Y,3) ',' num2str(R,3) ',' num2str(X,3) ':'];
fprintf(CNC.Config.Serial,pos_str);
fprintf(CNC.Config.Serial,':!GO1111:');

if(~block)
    CNC_CommandedPosition();
    status = true;
    return
end

move_duration = tic;
% If blocking move do not return until move complete
current = CNC_CurrentPosition();

% Check within 0.02mm of target position.
% 0.02 mm positional error aceptable to allowed for floating point errors
% in positional check.
while( ( any([X Y Z R]>(current+0.02)) || any([X Y Z R]<=(current-0.02)) ) && block )
    current = CNC_CurrentPosition();
    pause(0.1)
    
    if( toc(move_duration)>60 )
        CNC_Status();
    end
    
end

disp('In Position')
CNC_CommandedPosition();
CNC_CurrentPosition();
status = true;


% Check Commanded Position uploaded to controller sucesasfully
% if( CNC_CommandedPosition() == [D1 D2 D3 D4] )
%     disp('Commanded Position uploaded sucessfully.')
%     fprintf(CNC.Config.Serial,':!GO1111:');
% else
%     error('Commanded Position not uploaded sucessfully. Move not initiated.')    
% end
    
