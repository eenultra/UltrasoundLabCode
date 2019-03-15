%agoff

hydro = 2; % 1 for 1 mm, 2 for 0.2 mm, 3 for 0.04 mm, 4 for membrane
%LCmaxVDIV(lc,'C1');pause(0.1);

Frng = 0.7E6:0.1E6:1.4E6;
Run  = 1;%[1 2 3];
Ncy  = 5;
V    = 50;% mV

Prng  = zeros(250002,length(Frng),length(Run));
Ftrng = zeros(250002,length(Frng),length(Run));

for j=1:length(Run)
    for i=1:length(Frng)

        agSetFreq(Frng(i));

        lcclsw(lc);
        LCsetTRIG(lc,'NORM');
        pause(5);
        %agon  
        [x,y]= LCreadwf(lc,'C2'); % CHECK CONNECTED CHANNEL

        fs  = 1/(x(2) - x(1));
        P   = HydrophoneInverseFilter(y,fs,hydro);%y/0.213;%
        frq = linspace(0,fs/1E6,length(y));
        figure(1);plot(x*1E6,P/1E3);xlabel('Time ({\mu}s)');ylabel('Pressure (kPa)');
        %ylim([-250 250]);
        %Prms = sqrt(mean(P(16000:43720).^2))/1E3;
        PpkP  = max(P)/1E3;
        PpkN  = abs(min(P))/1E3;
        title(['PNP: ' num2str(round(PpkN)) ' kPa']);
        %title(['RMS Pressure: ' num2str(round(Prms)) ' kPa']);
        %disp(['RMS Pressure: ' num2str(round(Prms)) ' kPa']);

        Ft = 20*log10(abs(fft(P)))-max(20*log10(abs(fft(P))));
        figure(2);plot(frq,Ft);
        xlim([0.5 20]);ylim([-80 0]);xlabel('Freq (MHz)');ylabel('Magnitude (dB)');

        %title(['PNP: ' num2str(round(PpkN)) ' kPa']);
        disp(['PNP: ' num2str(round(PpkN)) ' kPa']);
        
        Prng(:,i,j)  = P;
        Ftrng(:,i,j) = Ft;
        
    end
end

LCsetTRIG(lc,'NORM');

save('1p1MHz_Transducer_Cal_02Jun14.mat','frq','x','Prng','Ftrng','Run','Frng','V','Ncy');

