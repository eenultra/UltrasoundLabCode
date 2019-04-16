% this code should be run on the output from all PCD processed by hifuPlot
% it will loop through all exposures and repeats 
%'out_20150823_R5_NR40_850nm_Lon_95mV' - this is an example of filename, it
% will read in this file and collate broadband/ultraharmonic data

% University of Leeds
% James McLaughlan
% April 2019

clear all

dV  = [20 40 60 80 100 120 140 160 180 200 220]; % different mV setting on Agilent for each repeat
Run = [1 2 3]; % number of repeats

% pre-alloc arrays
bbFall  = zeros(Nl,length(dV),length(Run));
ulFall  = zeros(Nl,length(dV),length(Run));
TbbFall = zeros(length(dV),length(Run));
TulFall = zeros(length(dV),length(Run));

for i=1:length(Run)
    for j=1:length(dV)
       load(['out_20170524_R' num2str(Run(i)) '_PH_839nm_Lon_40PC_' num2str(dV(j)) 'mV.mat']); % loads specific file for repeat (Run) and PNP (dV)
       bbFall(:,j,i) = bbF;  % puts all broadband data into a single arrays, for all exposures/repeats/PNP levels
       ulFall(:,j,i) = ulF;  % puts all ultraharmonic data into a single arrays, for all exposures/repeats/PNP levels
       TbbFall(j,i)  = TbbF; % puts all time integrated broadband data into a single arrays, for all exposures/repeats/PNP levels
       TulFall(j,i)  = TulF; % puts all time integrated ultraharmonic data into a single arrays, for all exposures/repeats/PNP levels      
       clear bbF ulF TbbF TulF
        
    end
end

save('20170524_All_PCD_Lon_PH.mat','t','bbFall','ulFall','TbbFall','TulFall','dV','Run'); % saves all data - manual file name change

