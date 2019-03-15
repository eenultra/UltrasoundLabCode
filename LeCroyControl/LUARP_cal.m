function LUARP_cal(lc,name)

[x,y]= LCreadwf(lc,'C1');pause(0.1);
%agSetFreq(1*1E6);
N  = length(x);
fs = round(1/(x(2)-x(1)));
clear x y

AvN = 5;
d1  = 2.20E-6; % delay setting for the voltage signal
d2  = 15.0E-6; % delay setting for the pressure reading 

P = zeros(N,AvN);
V = zeros(N,AvN);

    for j=1:AvN

        LCsetTRDL(lc,d2);
        LCsetTRIG(lc,'NORM');pause(0.5);LCsetTRIG(lc,'STOP');
        [x,y]= LCreadwf(lc,'C1');pause(0.1);
        P(:,j) = HydrophoneInverseFilter(y,fs,2); %0.2um hydrophone used.

    end

    for j=1:AvN

        LCsetTRDL(lc,d1);
        LCsetTRIG(lc,'NORM');pause(0.5);LCsetTRIG(lc,'STOP');
        [t,v]= LCreadwf(lc,'C2');pause(0.1);
        V(:,j) = v;

    end

Pm = mean(P,2);
Vm = mean(V,2);
Ps = std(P,0,2);
Vs = std(V,0,2);

save([name '_dat.mat'],'fs','P','V','x','t','Pm','Vm','Ps','Vs');

clear fs P V x t Pm Vm

%{

A  = 0.1:0.05:1;
%F  = 1E6:0.1E6:3E6;

PPP = zeros(length(A),1);
PPN = zeros(length(A),1);

for k=1:length(A)

    load(['LUARP_cal_02Aug12_A' num2str(A(k)) '_dat.mat']);
    %load(['LUARP_cal_02Aug12_F' num2str(F(k)/1E6) '_dat.mat']);

    PPP(k,1) = max(Pm);
    PNP(k,1) = abs(min(Pm));

end

%}


