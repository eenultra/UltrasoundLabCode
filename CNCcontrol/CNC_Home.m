%% Configure 6K4 controller
%
% Function Prototype:
%   [status] = CNC_ConfigureController()
%
% Long Description:
%   This function will open the specified COM port and configure the
%   terminator characters to char(26) as configured on the CNC system.
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

function [status] = CNC_Home()

global CNC

disp(' ')
disp(' ')
disp('WARNING! This function will guide the homing/alignment of the CNC system.')
disp('WARNING! Axis may move throughout the full motion range.')
disp('WARNING! Remove any items that may contact the moving CNC or parts connected to it.')
disp(' ')
code = round( 9999*rand(1,1) ) ;
disp(['To continue the process please enter the following code: ' num2str( code,'%.4u')] )
disp('To cancel press enter without entering code.' )
user_code = input('Enter code : ');

if( ~(code==user_code) )
    disp(' ')
    disp('Incorrect code entered. Cancelling homing function.')
    disp(' ')
    return
else
    disp(' ')
    disp('Correct code entered. Initiating homing process.')
    disp(' ')
    disp('In case of emergency: Press any emergency stop button to stop CNC system.')
    disp(' ')
end

%Set home acceleration to 10 units/sec/sec for all axes
fprintf(CNC.Config.Serial,':@HOMA10:')

%Set home average acceleration to 5 units/sec/sec for all axes (S-curve)
fprintf(CNC.Config.Serial,':@HOMAA5:')

% Set home deceleration to 25 units/sec/sec for all axes
fprintf(CNC.Config.Serial,':@HOMAD25')			

% Set home average deceleration to 12.5 units/sec/sec for all axes (S-curve)
fprintf(CNC.Config.Serial,':@HOMADA12.5')		

% Set home active level to low on axes 1-4
%fprintf(CNC.Config.Serial,':LIMLVLxx0xx0xx0xx0') 

% Set home velocity to 5 units/sec for all axes
fprintf(CNC.Config.Serial,':@HOMV5')			

% Sets home final velocity to 0.1 units/sec for all axes
fprintf(CNC.Config.Serial,':@HOMVF1')			

% Disable homing to encoder Z-channel on all axes
fprintf(CNC.Config.Serial,':HOMZ0000')


% Enable backup to home switch on all axes
%fprintf(CNC.Config.Serial,':HOMBAC1100')			
fprintf(CNC.Config.Serial,':HOMBAC1111')

% Set final home direction to positive on all axes.
%fprintf(CNC.Config.Serial,':HOMDF0000')			
fprintf(CNC.Config.Serial,':HOMDF0000')

% Axes 1 & 2 stop on the positive-direction edge of the home switch, axes 3 and 4 are to stop on negative-direction side
%fprintf(CNC.Config.Serial,':HOMEDG0011')		
fprintf(CNC.Config.Serial,':HOMEDG0000') %0=Pos, 1=Neg, x=Don't change.		

for(t=10:-1:1)
    disp(['Homing in ' num2str(t) ' seconds.'])
    beep()
    pause(1)
end

disp('Homing X-axis')
fprintf(CNC.Config.Serial,':HOMXXX1:'); 

% Wait for homing to complete on X-axis
CNC_Status()
while( ~CNC.Home(1) )
    pause(0.5)
    CNC_Status();
end
    
disp('Homing Y-axis')
fprintf(CNC.Config.Serial,':HOMX1XX:');

% Wait for homing to complete on Y-axis
CNC_Status()
while( ~CNC.Home(2) )
    pause(0.5)
    CNC_Status();
end

disp('Homing Z-axis')
fprintf(CNC.Config.Serial,':HOM0XXX:');
% Wait for homing to complete on Z-axis
CNC_Status()
while( ~CNC.Home(3) )
    pause(0.5)
    CNC_Status();
end

% % Wait for homing to complete on Z-axis
% disp('Homing R-axis')
% fprintf(CNC.Config.Serial,':HOMXX1X:');
% CNC_Status()
% while( ~CNC.Home(4) )
%     pause(0.5)
%     CNC_Status();
% end
