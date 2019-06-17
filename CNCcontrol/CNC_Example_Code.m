global CNC

% Set default parameters
CNC.SoftwareLimits.X.Values = [-20 36];
CNC.SoftwareLimits.X.Enabled = true;
CNC.SoftwareLimits.Y.Values = [0 0];
CNC.SoftwareLimits.Y.Enabled = false; 
CNC.SoftwareLimits.Z.Values = [0 0];
CNC.SoftwareLimits.Z.Enabled = false;
CNC.SoftwareLimits.R.Values = [-180 180];
CNC.SoftwareLimits.R.Enabled = true;

CNC_OpenConnection('COM3');
CNC_EnableDrives();

disp('Remove clamps from vertical (Z) axis. Then press any key to continue.')
pause

CNC_Home();
CNC_Status();

CNC_CurrentPosition() 
CNC_CommandedPosition()
 
%% Move position at fixed axis velocity.
% Different axis may arrive in position at different times.
% Non-linear motion

CNC_MovePosition(10,10,0,0,true);
CNC_MovePosition(0,0,0,0,true);

%% Move position at fixed path velocity
% Differnt axis travel at different velocities to arrive at same time.
% Linear motion - Point-to-Point

CNC_MovePositionLinear(50,25,10,0,true);
CNC_MovePositionLinear(0,0,0,0,true);




%% Step through cartesian grid of points


% X_range = 0:1:5
% Y_range = 0:1:5
% Z_range = 0:1:5
% R_range = 0:1:5
% 
% [X,Y,Z,R] = ndgrid(X_range,Y_range,Z_range,R_range);
% 
% 
% figure(1)
% plot3(X(:),Y(:),Z(:))
% xlabel('x');ylabel('y');zlabel('z');
% 
% total_points = numel(X)
% 
% for position = 1:total_points
%     position
%     CNC_MovePositionLinear(X(position),Y(position),Z(position),0,true);
% end


X_range = 10:10:30
Y_range = 10:10:30
Z_range = 10:10:30
R_range = 10:10:30

[X,Y,Z,R] = ndgrid(X_range,Y_range,Z_range,R_range);


figure(1)
plot3(X(:),Y(:),Z(:))
xlabel('x');ylabel('y');zlabel('z');

total_points = numel(X)

for position = 1:total_points
    position
    CNC_MovePositionLinear(X(position),Y(position),Z(position),0,true);
end


%% Park CNC system



