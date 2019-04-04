%'out_20150823_R5_NR40_850nm_Lon_95mV'
clear all

dV  = [20 40 60 80 100 120 140 160 180 200 220];
Run = [1 2 3];
Nl  = 1700;

bbFall  = zeros(Nl,length(dV),length(Run));
ulFall  = zeros(Nl,length(dV),length(Run));
TbbFall = zeros(length(dV),length(Run));
TulFall = zeros(length(dV),length(Run));

for i=1:length(Run)
    for j=1:length(dV)
       load(['out_20170524_R' num2str(Run(i)) '_PH_839nm_Lon_40PC_' num2str(dV(j)) 'mV.mat']);
       %out_20161130_R1_NR_825nm_Loff_80mV
       bbFall(:,j,i) = bbF;
       ulFall(:,j,i) = ulF;
       TbbFall(j,i)  = TbbF;
       TulFall(j,i)  = TulF;
       
       clear bbF ulF TbbF TulF
        
    end
end

save('20170524_All_PCD_Lon_PH.mat','t','bbFall','ulFall','TbbFall','TulFall','dV','Run');

