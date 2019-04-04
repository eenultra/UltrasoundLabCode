% basic code to batch plot all quasi-CW HIFU data saved during hifuAll code

% University of Leeds
% James McLaughlan
% April 2019

pnp = [0.20 0.62 0.91 1.19 1.43 1.69 1.92 2.13 2.34 2.53 2.71];

ln  = 2;
fnt = 18;
Run = 3;

for i=1:Run
    for j =1:length(pnp) %PNP
        plot(t-1,bbFall(:,j,i),'color',[127.5 0 0]/255,'LineWidth',ln);
        %plot(t-1,bbF,'color',[0.5 0 0],'LineWidth',ln);
        axis([-1 16 -1 50]);
        xlabel('Time (s)','FontSize',fnt);
        ylabel('Inertial Cavitation Dose (dB)','FontSize',fnt);
        set(gca,'LineWidth',ln,'FontSize',fnt);
        fname = ['nrOff_bbPCD_' num2str(dV(j)) 'mV_R' num2str(i)];
        %fname = 'Loff-on_bbPCD_140mV_Run3';
        saveas(gcf,fname,'tiffn');saveas(gcf,fname,'epsc');      
    end
end

%phOn 'color',[33 64 154]/255 
%nrOff 'color',[127.5 0 0]/255
%nrOn 'color',[8 135 67]/255

% clear all;load('20170524_All_PCD_Lon_PH.mat');PCDplot

%% This is just processing images, not needed 

load('20170524_R1_NR_839nm_Loff_40PC_120mV');fmP1nrOff = frames(:,:,:,161);
load('20170524_R2_NR_839nm_Loff_40PC_160mV');fmP2nrOff = frames(:,:,:,161);

load('20170524_R3_NR_839nm_Lon_40PC_120mV');fmP1nrOn = frames(:,:,:,161);
load('20170524_R3_NR_839nm_Lon_40PC_160mV');fmP2nrOn = frames(:,:,:,161);

load('20170524_R2_PH_839nm_Lon_40PC_120mV');fmP1phOn = frames(:,:,:,161);
load('20170524_R3_PH_839nm_Lon_40PC_160mV');fmP2phOn = frames(:,:,:,161);

clear frames

%%

% PCD examples are 120 (6) &160mV (8)
clear all
load('20170524_All_PCD_Loff_NR.mat');P1nrOff = bbFall(:,6,1);P2nrOff = bbFall(:,8,2);clear bbFall;
load('20170524_All_PCD_Lon_NR.mat');P1nrOn = bbFall(:,6,3);P2nrOn = bbFall(:,8,3);clear bbFall;
load('20170524_All_PCD_Lon_PH.mat');P1phOn = bbFall(:,6,2);P2phOn = bbFall(:,8,1);clear bbFall;
%%

ln  = 2;
fnt = 22;

plot(t-1,P2phOn,'color',[33 64 154]/255,'LineWidth',ln);
axis([-1 16 -1 55]);
legend('+HIFU/+LS/-NR','Location','northwest');
xlabel('Time (s)','FontSize',fnt);
ylabel('Inertial Cavitation Dose (dB)','FontSize',fnt);
set(gca,'LineWidth',ln,'FontSize',fnt);
saveas(gcf,'egBB2_phOn','epsc');saveas(gcf,'egBB2_phOn','png');

% [127.5 0 0]/255 dark red
% [8 135 67]/255 green
% [33 64 154]/255 blue


