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

function [status] = CNC_MovePositionLinear(X,Y,Z,R,block)

global CNC

% Set destination position // Z Y R X	
pos_str = [':!D' num2str(Z,'%10.2f') ',' num2str(Y,'%10.2f') ',' num2str(R,'%10.2f') ',' num2str(X,'%10.2f') '::!GOL1111:'];
fprintf(CNC.Config.Serial,pos_str);
%fprintf(CNC.Config.Serial,':!GOL1111:');

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
tol = 0.02;

%Check tolerance reached
request = [X Y Z R];
error = max(abs(current-request));
while((error > tol) && block )
    pause(0.1);
    current = CNC_CurrentPosition();
    error = max(abs(current-request));
    
    if(toc(move_duration)>1)
        display(['CNC positional error : ' num2str(error) ' mm. Repeating move command.';])
        fprintf(CNC.Config.Serial,pos_str);
        %fprintf(CNC.Config.Serial,':!GOL1111:');
    end
    
    %Have you been trying longer than 60s to get there?
    if(toc(move_duration)>60)
        CNC_Status();
        CNC_CommandedPosition();
        CNC_CurrentPosition();
        display(['CNC positional error : ' num2str(error) ' mm. CNC timed out. SYSTEM PAUSED';])
        
        status = false;
        
        pause
        break;
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
    
