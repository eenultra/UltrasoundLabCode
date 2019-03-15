
%Transducer calibration for both 2.25 and 5.00 MHz unfocused transducers.
%Use ARB_JM to excite, i.e. a tukey windowed to 20 cycles independent of
%freq

name = '5MHz_100kPa_Vcal_01Nov12'; %'5MHz_50mV_Pcal_01Nov12' file name

Nc      = 20;      % number of cycles is ARB waveform
fst     = 3E6;     % Start sweep frequency
fen     = 8E6;     % End Sweep frequency
fres    = 0.1E6;   % Freq resolution
hydro   = 1;       % 1 for 1 mm, 2 for 0.2 mm
Volt    = 495;     % Start voltage, in mV
Ptarget = 100E3;    % Target Pressure in Pa
Perr    = 0.025;   % +/- error on Ptarted tol by the program
Vdiv    = 2;       % Amount ARB voltage is changed to reach correct pressure

fr = round(linspace(fst/Nc,fen/Nc,((fen-fst)/fres)+1));

[x,y] = LCreadwf(lc,'C1');pause(0.1);
Nl    = length(y);
clear x y

Pswp = zeros(Nl,length(fr));
Pmax = zeros(length(fr),1);
Pmin = zeros(length(fr),1);
Dvol = zeros(length(fr),1);

for i=1:length(fr)
   
    Ptest   = 0; % will run while loop if Ptest =~ Ptarget
    disp(['Freq ' num2str((fr(i)*Nc)/1E6) ' MHz, Pressure ' num2str(Ptarget/1E3) ' kPa']);
    
    while Ptest == 0
    
    agoff
    agSetFreq(fr(i));
    agSetVolt(Volt*1E-3);
    lcclsw(lc);pause(0.1);
    agon
    pause(0.7);
    agoff
    
    [x,y]= LCreadwf(lc,'C1');pause(0.1);
    fs = 1/(x(2) - x(1));
    P  = HydrophoneInverseFilter(y,fs,hydro); 
    
    Pval = abs(min(P));
    
        if Pval >= (Ptarget - (Ptarget*Perr)) && Pval <= (Ptarget + (Ptarget*Perr))
            Ptest = 1;
        else
            if Pval <= (Ptarget - (Ptarget*Perr))
                Volt = Volt + Vdiv;
            elseif Pval >= (Ptarget + (Ptarget*Perr))
                Volt = Volt - Vdiv;
            end
        end
    end
    
    %{
    agoff
    agSetFreq(fr(i));
    agSetVolt(Volt*1E-3);
    lcclsw(lc);pause(0.2);
    agon
    pause(0.7);
    agoff
    
    [x,y]= LCreadwf(lc,'C1');pause(0.1);
    fs = 1/(x(2) - x(1));
    P  = HydrophoneInverseFilter(y,fs,hydro);
    %}
    
    Dvol(i,1) = Volt;
    Pswp(:,i) = P;
    Pmax(i,1) = max(P);
    Pmin(i,1) = abs(min(P));
    t         = x;
    clear x y fs P     
end

save(name,'fst','fen','fres','fr','Pswp','Pmax','Pmin','Dvol','t')



