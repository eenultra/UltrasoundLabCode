% Example Matlab code used for controlling the spectrum DAQ card and saving
% both channels of data
%
% James McLaughlan
% Mar 2019
% University of Leeds
%

clearvars -except lc ZO QC AG PWM RT % clears workspace apart from specific variables

Na   = 50;                   % number of pulses per position

%Initialise the DAQ Card
SPcardSt(500,500,18) % set dyanmic range of DAQ card
global cardInfo

data   = zeros(cardInfo.setMemsize,Na);

%%
name = 'PhantomPath_r1';
input('\nReady?');   

    Ch0_data = zeros(cardInfo.setMemsize,Na);
    Ch1_data = zeros(cardInfo.setMemsize,Na);

            for L = 1:Na
                [t,DAT]   = SPcardAq; % aquire data
                Ch0_data(:,L) = DAT(:,1);
                Ch1_data(:,L) = DAT(:,2);
            end
            
            figure(1);plot(t,Ch0_data(:,Na),'r');title('Receive TXD');xlabel(gca,'Time (us)');ylabel('Ch0 Voltage (V)'); %will plot last pulse
            figure(2);plot(t,Ch1_data(:,Na));title('Transmit TXD');xlabel(gca,'Time (us)');ylabel('Ch1 Voltage (V)'); %will plot last pulse

disp('Saving....');
save([name '_dat.mat'],'t','Ch0_data','Ch1_data');

%%

SPcardEn;