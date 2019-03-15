
fswp = (1:0.1:7)*1E6; % Frequency Sweep

name = 'ARB_3p5MHz_1-7MHz_SNX846_15Apr13';
  
%agSetFreq(1*1E6);
N  = 50002;
fs = 2.5E9;
Ns = 20; % 20 cycles for JM_ARB on FG

d1 = 7.36E-6;%4.0E-6;%2.40E-6; % delay setting for the voltage signal
d2 = 17.48E-6;%19.0E-6;%31.0E-6; % delay setting for the pressure reading     

P = zeros(N,length(fswp));
V = zeros(N,length(fswp));

for i=1:length(fswp)
    
    agSetVolt(100/1E3);%Xy(i,2)
    agSetFreq(fswp(i)/Ns);
    
    lcclsw(lc);pause(0.5);
    
    LCsetTRDL(lc,d2);pause(0.1);
    LCsetTRIG(lc,'NORM');pause(1);LCsetTRIG(lc,'STOP');
    [x,y]= LCreadwf(lc,'C2');pause(0.1);
    LCsetTRDL(lc,d1);pause(0.1);
    LCsetTRIG(lc,'NORM');pause(1);LCsetTRIG(lc,'STOP');
    [t,v]= LCreadwf(lc,'C1');pause(0.1);
    
    P(:,i) = HydrophoneInverseFilter(y,fs,2); %0.2um hydrophone used.
    V(:,i) = v;
    
end

save([name '.mat'],'fs','P','V','x','t');

LCsetTRIG(lc,'NORM');
agoff;


