% Processess PCD data from quasi-CW exposures when using the biolab DAQ, sonic concepts hydrophone etc 
% see
% https://www.jove.com/video/58045/controllable-nucleation-cavitation-from-plasmonic-gold-nanoparticles
% for experimental details
% this code will run through all experimental data so takes a long time.
% Best to leave to batch processing overnight.
% needs 'comb.m' to generate comb filter to remove HIFU harmonics. 
% please note that some of this code is quite old and there are better ways
% of implementing it. So please make improvements where possible.

% University of Leeds
% James McLaughlan
% April 2019

clear all
close all

%%

n     = 170;    % number of repeat loops, this values is for a 15s exposure, 1s data before/after at a rate of 10Hz
Na    = 248832; % length of data from DAQ from each trigger 
Ni    = 24883;  % length of the data used for each FFT calculation, should be int div of Na, i.e. Ni = Na/10;
fs    = 250E6;  % sample freq of DAQ card. This will generally be 250 MHz
N     = 2^16;   % number of zeros added for zero padding for FFT
Vpad  = zeros(N,1); % create zero padded array
win   = tukeywin(N,0.25); % create a window function for FFT - not sure how effective this is as it windos the zero data aswell. Might be best just over the non-zero data
id1   = round((N/2)-(Ni/2)); % finds start location for real data in zero padded array
id2   = round((N/2)+(Ni/2)); % finds end location for real data in zero padded array
dur   = 15; % HIFU exposure time


SI  = ls('20170524*.mat'); % loads in all .mat data with a specific date at the beginning. This is down to my naming convention
si  = size(SI);

%%

for j=1:si(1) % loops through all files found in SI

    id   = find(SI(j,:) == '.',1,'last'); % a bit of an inefficient way to get filename, but it works!
    name = SI(j,1:id-1);
    disp(name);
    disp(['no. ' num2str(j) ' of ' num2str(si(1))]); % tells location in data processing
    load([name '.mat']); %loaded in DAQ data for processing

    dat = reshape(data,Na*n,1); % reshapes array from mxn into a single vector mx1
    Len = round((Na*n)/Ni); % number of segments used for FFT cal

    % pre-alloc
    F_dat = zeros(N,Len); % fft data
    Freq  = linspace(0,fs,length(F_dat))/1E6; % create a freq scale
    bbF   = zeros(Len,1); % broadband data
    ulF   = zeros(Len,1); % ultraharmonic data

    %%%%
    % comb filter.m - this loads the variable for a combfilter 
    % it needs to be adjusted for given dataset / sample freq / sample length etc
    load('CombFiltNew.mat'); %ulComb & bbComb
    %%%%

    inSt = find(Freq >= 5.0 & Freq <=5.1,1,'First');   % finds start freq of integration range, 5 MHz
    inEn = find(Freq >= 20.0 & Freq <=20.1,1,'First'); % find end freq of integration range, 20 MHz

    for i=1:Len % loops through dat taking sections for FFT analysis

        st = 1  + (Ni * (i-1)); % finds start of specific section in data vector
        sp = Ni + (Ni * (i-1)); % finds end of specific section in data vector

        temp              = dat(st:sp); % current data section
        Vpad(id1:id2-1,1) = temp;       % adds to correct location in zero pad
        windat            = win.*Vpad;  % applies windowing function
        F_dat(:,i)        = abs(fft(windat)); % does FFT on zero padded / windowed data set

        % integrates over specified freq band with applied comb filter
        bbF(i,1)   = 20*log10(trapz((F_dat(inSt:inEn,i).*bbComb(inSt:inEn)))); % broadband value (in dB) for specific section of data
        ulF(i,1)   = 20*log10(trapz((F_dat(inSt:inEn,i).*ulComb(inSt:inEn)))); % ultraharmonic value (in dB) for specific section of data

    end

    t   = linspace(0,17,Len); % creates time vector
    tSt = find( t>= 1.0 &  t <=1.1,1,'First'); % finds HIFU on time
    tEn = find( t>= 16.0 & t <=16.1,1,'First'); % finds HIFU off time

    bbF  = bbF-bbF(1,1); % scales dB value with noise level from no HIFU
    ulF  = ulF-ulF(1,1); % scales dB value with noise level from no HIFU
    TbbF = trapz(bbF(tSt:tEn))/dur; % integrates broadband over all HIFU exposure duration
    TulF = trapz(ulF(tSt:tEn))/dur; % integrates ultraharmonic over all HIFU exposure duration
    
    save(['out_' name '.mat'],'t','bbF','ulF','F_dat','TbbF','TulF'); % saves data with same file name as inputted with 'out_' at the front to be read by hifuAll
    % loops to next data set
end



%{
ln  = 2;
fnt = 18

plot(t-1,bbF,'LineWidth',ln);
axis([-1 17 -1 40]);
xlabel('Time (s)','FontSize',fnt);
ylabel('Inertial Cavitation Dose (dB)','FontSize',fnt);
set(gca,'LineWidth',ln,'FontSize',fnt);









%}


