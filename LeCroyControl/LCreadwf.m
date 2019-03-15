function [x y]= LCreadwf(lc,str)

%James McLaughlan
%Leeds University
%May 2011

%{
%% MAKE CONNECTION AND READ DATA FROM SCOPE %%
lc = actxcontrol('LeCroy.ActiveDSOCtrl.1') % Load ActiveDSO control
invoke(lc,'MakeConnection','IP:192.168.1.2'); % Substitute your choice of IP address here
invoke(lc,'WriteString','*IDN?',true); % Query the scope name and model number
%ID=invoke(lc,'ReadString',1000) % Read back the scope ID to verify connection

% % THESE COMMANDS CAN BE UNCOMMENTED TO SHOW EXAMPLE IEEE488.2 COMMUNICATION
% invoke(lc,'WriteString','C3:TRA ON',true); % Turn channel 3 on (for example)
% invoke(lc,'WriteString','C4:TRA OFF',true); % Turn channel 4 off (for example)
% invoke(lc,'WriteString','TRSE EDGE,SR,C2,HT,OFF',true); % Set trigger source to be another channel, for example channel 2
% invoke(lc,'WriteString','Sequence On',true); % Turn On Sequence Mode
%}
% % % TRANSFER WAVEFORM FROM SCOPE TO MATLAB 
Cdat=invoke(lc,'GetScaledWaveformWithTimes',str,1000000,0); % Get Wavefrom Data - 1 Mpts is chosen as the arbitrary maximum file transfer file size (substitute your own max value to use) 
Cdat=double(Cdat)'; % ActiveDSO transfers single precision matrix.  Need to convert to double to plot in Matlab. 

x = Cdat(:,1);
y = Cdat(:,2);

%{
% DATA HAS BEEN TRANSFERRED -- TERMINATE CONNECTION WITH SCOPE 
invoke(lc,'Disconnect'); % disconnect from scope
close(gcf); % close current figure that had been opened by the activexcontrol
%}
