
fswp = 3.3E6;%(1:0.25:7)*1E6; % Frequency Sweep
pswp = 20:20:400;%20:20:440; % Voltage Sweep 

lcclsw(lc);pause(0.5);

name = 'HIFU_f23p3MHz_20-400mV_R3_13Dec13';
  
%agSetFreq(1*1E6);
N  = 100002;%50002;
fs = 2.5E9;
Ns = 1; % 20 cycles for JM_ARB on FG

d1 = 4.44E-6; % delay setting for the voltage signal
d2 = 44.96E-6; % delay setting for the pressure reading     

P = zeros(N,length(fswp),length(pswp));
V = zeros(N,length(fswp),length(pswp));

for j=1:length(pswp)

    for i=1:length(fswp)
        
        %agoff
        agSetVolt(pswp(j)/1E3);%Xy(i,2)
        agSetFreq(fswp(i)/Ns);pause(0.1);
        agon

        %lcclsw(lc);pause(0.5);

        LCsetTRDL(lc,d2);pause(0.1);
        LCsetTRIG(lc,'NORM');pause(0.5);
        LCmaxVDIV(lc,'C2');pause(0.5);
        LCmaxVDIV(lc,'C2');pause(0.5);
        %lcclsw(lc);pause(0.5);
        LCsetTRIG(lc,'STOP');
        [x,y]= LCreadwf(lc,'C2');pause(0.1);
        
        LCsetTRDL(lc,d1);pause(0.1);
        LCsetTRIG(lc,'NORM');pause(0.5);
        LCmaxVDIV(lc,'C1');pause(0.5);
        LCmaxVDIV(lc,'C1');pause(0.5);
        %lcclsw(lc);pause(0.5);
        LCsetTRIG(lc,'STOP');
        [t,v]= LCreadwf(lc,'C1');pause(0.1);

        P(:,i,j) = y/0.211;%HydrophoneInverseFilter(y,fs,2); %0.2um hydrophone used.
        V(:,i,j) = v;
        
        
    end
    agoff
end

P = squeeze(P);
V = squeeze(V);

save([name '.mat'],'fs','P','V','x','t','fswp','pswp');

LCsetTRIG(lc,'NORM');
agSetVolt(20E-3);
agon;


