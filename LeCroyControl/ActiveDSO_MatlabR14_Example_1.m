% This Matlab script transfers data between a LeCroy XStreamDSO scope and Matlab (either running on a separate computer or residing on the scope) using ActiveDSO via LAN
% Instructions: Install ActiveDSO on computer or scope, set scope IP address (or use 127.0.0.1 if installed on scope), then type m-file name at computer prompt
% This script (updated 8/27/2004) has been tested for Matlab R14 (version 7.0)  

%% MAKE CONNECTION AND READ DATA FROM SCOPE %%
DSO = actxcontrol('LeCroy.ActiveDSOCtrl.1'); % Load ActiveDSO control
invoke(DSO,'MakeConnection','IP:192.168.1.2'); % Substitute your choice of IP address here
invoke(DSO,'WriteString','*IDN?',true); % Query the scope name and model number
ID=invoke(DSO,'ReadString',1000); % Read back the scope ID to verify connection
%close gcf

% % THESE COMMANDS CAN BE UNCOMMENTED TO SHOW EXAMPLE IEEE488.2 COMMUNICATION
% invoke(DSO,'WriteString','C3:TRA ON',true); % Turn channel 3 on (for example)
% invoke(DSO,'WriteString','C4:TRA OFF',true); % Turn channel 4 off (for example)
% invoke(DSO,'WriteString','TRSE EDGE,SR,C2,HT,OFF',true); % Set trigger source to be another channel, for example channel 2
% invoke(DSO,'WriteString','Sequence On',true); % Turn On Sequence Mode

% % % TRANSFER WAVEFORM FROM SCOPE TO MATLAB 
channel1data=invoke(DSO,'GetScaledWaveformWithTimes','C1',1000000,0); % Get Wavefrom Data - 1 Mpts is chosen as the arbitrary maximum file transfer file size (substitute your own max value to use) 
channel1data=double(channel1data); % ActiveDSO transfers single precision matrix.  Need to convert to double to plot in Matlab. 

% DATA HAS BEEN TRANSFERRED -- TERMINATE CONNECTION WITH SCOPE 
invoke(DSO,'Disconnect'); % disconnect from scope
close(gcf); % close current figure that had been opened by the activexcontrol

% WRITING DATA TO A TEXT FILE %% uncomment these lines to output the data directly to a text file
% fid = fopen('output.txt','w');
% fprintf(fid,'   Time      Amplitude\n');
% for i=1:length(channel1data)
%     fprintf(fid,'%15.12f  %10.6f \n',channel1data(1,i),channel1data(2,i));
% end
% fclose(fid);
  
%% PLOTTING DATA %%
figure
plot(channel1data(1,:),channel1data(2,:)); % plot figure
title('XStreamDSO Waveform Data'); % label title
xlabel('s'); % label x axis
ylabel('V'); % label y axis

