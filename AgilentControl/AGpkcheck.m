
frng = 1.5E6:0.25E6:7E6;%3E6:0.25E6:8E6;
fs   = 2.5E9;

target = 100E3; % target pressure in Pa

file = 'Atten_NoMB_R3_24Apr13';%JefUV%NoMB

Vmx =zeros(length(frng),1);
Vmn =zeros(length(frng),1);

for i=1:length(frng)
    
    f0 = frng(i);
    Fname = ['Freq_' num2str(f0/1E6) '_MHz_' file];
    load([Fname '.mat'])
    
    Vmx(i,1) = max(HydrophoneInverseFilter(mean(v,2),fs,1));
    Vmn(i,1) = abs(min(HydrophoneInverseFilter(mean(v,2),fs,1)));
    
end

figure(1);plot(frng/1E6,Vmx,'.',frng/1E6,Vmn,'.');

scale = Vmx/target;

%Voltage_values = [360 280 220 165 135 110 98 80 70 56 52 51 54 62 75 94 104 122 168 220 245 300 385]*1e-3; % for 150 kPa with 3.5 MHz txd XXX846

figure(2);plot(frng/1E6,Voltage_values./scale','.');