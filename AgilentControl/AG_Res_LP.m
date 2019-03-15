function AG_Res_LP(lc,Dvol,fname)

% lfile = '5MHz_50kPa_Dvolt.mat'
% fname = '5MHz_50kPa_NoMB_R1_01Nov12'

Nc      = 20;      % number of cycles is ARB waveform
fst     = 3E6;     % Start sweep frequency
fen     = 8E6;     % End Sweep frequency
fres    = 0.5E6;   % Freq resolution
hydro   = 1;       % 1 for 1 mm, 2 for 0.2 mm
n       = 200;
dat_L   = 50002;
Ptarget = '150';

invoke(lc,'WriteString',['SEQ ON,' num2str(n) ',' num2str(dat_L-2)],true);
LCsetTRIG(lc,'ARM');
fr = round(linspace(fst/Nc,fen/Nc,((fen-fst)/fres)+1));

agon;pause(0.1);

[x,y] = LCreadwf(lc,'C1');pause(0.1);
fs    = 1/(x(2) - x(1));
Nl    = dat_L;
clear x y

agoff
lcclsw(lc)

pad_dat   = zeros(2^16,n);
FFT       = NaN(Nl+2*length(pad_dat(:,1)),n);
Freq      = linspace(0,fs,Nl+2*length(pad_dat(:,1)));
ft        = zeros(length(FFT),length(fr));
fts       = zeros(length(FFT),length(fr));
fmax      = zeros(length(fr),1);

st = 50;
en = 650;

input('Add bubbles...');pause(20);

for i=1:length(fr)
    
    %input('Add bubbles...');pause(20);
    
    %j = length(fr) - (i-1);
    j = i; 
    disp(['Freq ' num2str((fr(j)*Nc)/1E6) ' MHz, Pressure ' Ptarget ' kPa']); %
       
    agSetFreq(fr(j));
    agSetVolt(Dvol(j)*1E-3);
    LCsetTRIG(lc,'ARM');pause(0.1);

    agon;pause(2.8);agoff
    
    [x,y]= LCreadwf(lc,'C1');pause(0.1);
 
    t = reshape(x,Nl,n);
    v = reshape(y,Nl,n);
    
    vn     = v(:,:);
    pad    = [pad_dat;vn(:,:);pad_dat];
    dln    = length(pad); 
    win    = gencoswin('hann',Nl);   % FFT windowing function
    winp   = [pad_dat(:,1);win;pad_dat(:,1)];

     for k=1:n
         win_dat    = pad(:,k).*winp;
         FFT(:,k)   = sqrt(2)*abs(fft(win_dat))/dln;
     end
    
     ft(:,j)  = mean(FFT(:,:),2);  
     fts(:,j) = sum(FFT(:,:),2);
     fmax(j,1) = max(20*log10(fts(st:en,j)));
     
     clear win_dat x_pres pad win winp dln
    
end

save(fname,'Freq','ft','fts','fmax');
    
    

