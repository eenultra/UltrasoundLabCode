%% This code has the objective to find the optimal point of reading
%

global CNC

% Set default parameters
CNC.SoftwareLimits.X.Values = [0 0];
CNC.SoftwareLimits.X.Enabled = false;
CNC.SoftwareLimits.Y.Values = [0 0];
CNC.SoftwareLimits.Y.Enabled = false; 
CNC.SoftwareLimits.Z.Values = [0 0];
CNC.SoftwareLimits.Z.Enabled = false;
CNC.SoftwareLimits.R.Values = [-180 180];
CNC.SoftwareLimits.R.Enabled = true;

disp('Remove clamps from vertical (Z) axis. Then press any key to continue.')
pause

CNC_Home();
CNC_Status();

CNC_CurrentPosition()
CNC_CommandedPosition()

CNC_MovePosition(0,0,0,0,true);
