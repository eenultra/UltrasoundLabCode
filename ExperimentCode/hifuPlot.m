

% University of Leeds
% James McLaughlan
% April 2019

clear all
close all

%%

n     = 170;
Na    = 248832;
Ni    = 24883;%2^10;
fs    = 250E6;
N     = 2^16;
Vpad  = zeros(N,1);
win   = tukeywin(N,0.25);
id1   = round((N/2)-(Ni/2));
id2   = round((N/2)+(Ni/2));
dur   = 15;


SI  = ls('20170524*.mat');
si  = size(SI);

%%

for j=1:si(1)

    id   = find(SI(j,:) == '.',1,'last');
    name = SI(j,1:id-1);
    disp(name);
    disp(['no. ' num2str(j) ' of ' num2str(si(1))]);
    %name = '20170524_R1_NR_839nm_Lon_40PC_120mV';
    load([name '.mat']);

    dat = reshape(data,Na*n,1);
    Len = round((Na*n)/Ni);

    F_dat = zeros(N,Len);
    Freq  = linspace(0,fs,length(F_dat))/1E6;
    bbF   = zeros(Len,1);
    ulF   = zeros(Len,1);

    %%%%
    % comb filter
    load('CombFiltNew.mat'); %ulComb & bbComb
    %%%%

    inSt = find(Freq >= 5.0 & Freq <=5.1,1,'First');
    inEn = find(Freq >= 20.0 & Freq <=20.1,1,'First');

    for i=1:Len

        st = 1  + (Ni * (i-1)); 
        sp = Ni + (Ni * (i-1));

        temp              = dat(st:sp);
        Vpad(id1:id2-1,1) = temp;
        windat            = win.*Vpad;
        F_dat(:,i)        = abs(fft(windat));%sqrt(2)*abs(fft(dat)/length(dat));

        bbF(i,1)   = 20*log10(trapz((F_dat(inSt:inEn,i).*bbComb(inSt:inEn))));
        ulF(i,1)   = 20*log10(trapz((F_dat(inSt:inEn,i).*ulComb(inSt:inEn))));

        %plot(temp);title(num2str(i));drawnow;pause(0.1);
        %disp(['st =' num2str(st) ' sp =' num2str(sp)]);
    end

    t   = linspace(0,17,Len);
    tSt = find( t>= 1.0 &  t <=1.1,1,'First');
    tEn = find( t>= 16.0 & t <=16.1,1,'First');

    bbF  = bbF-bbF(1,1);
    ulF  = ulF-ulF(1,1);
    TbbF = trapz(bbF(tSt:tEn))/dur;
    TulF = trapz(ulF(tSt:tEn))/dur;
    
    save(['out_' name '.mat'],'t','bbF','ulF','F_dat','TbbF','TulF');
    
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


