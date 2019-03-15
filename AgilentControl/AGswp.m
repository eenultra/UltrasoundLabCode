%Level(1,1) = 2;
%Level(1,2) = 42;

Level = load('TXD_level.csv');
si    = size(Level);
dur   = 10E-6; %pulse duration

dat_L = 50002;%50002;%25002;%12502 
n     = 200;

LCsetTRIG(lc,'STOP')
agoff

t = zeros(dat_L,n);
v = zeros(dat_L,n);

file = 'FF_NoMB_R1_28Jun13';%JefUV%NoMB
input('Ready?');

for i=1:si(1)%si(1):-1:1%
   
    j=i;
    %j=si(1)-(i-1);
    
    agSetFreq(Level(j,1)*1E6);
    agSetVolt((Level(j,2)/1E3)*2);
    burstcount = round((Level(j,1)*1E6)*dur);
    fprintf(AG,['SOUR:BM:NCYC ' num2str(burstcount)]);

    Fname = ['Freq_' num2str(Level(j,1)) '_MHz_' file];
    disp(['Freq = ' num2str(Level(j,1)) 'MHz Level = ' num2str(Level(j,2)) 'mV']);
    
    %
    %input('Ready?');
    %disp(' ');
    %{
    if Level(i,1) == 2 
        input('Ready?');
    elseif Level(i,1) == 3 
        input('Ready?');
    elseif Level(i,1) == 4 
        input('Ready?');
    elseif Level(i,1) == 5 
        input('Ready?');
    elseif Level(i,1) == 6 
        input('Ready?');
    elseif Level(i,1) == 7 
        input('Ready?');
    elseif Level(i,1) == 8 
        input('Ready?');
    end  
    %}
    %{
    if     Level(i,1) == 3.5 
        input('Ready?');
    elseif Level(i,1) == 4.5 
        input('Ready?');
    elseif Level(i,1) == 5.5 
        input('Ready?');
    elseif Level(i,1) == 6.5 
        input('Ready?');
    elseif Level(i,1) == 7.5 
        input('Ready?');
    end
    %}
    
    agon
    
    %vdiv=LCmaxVDIV(lc,'C1');
    %pause(0.1);
        
    invoke(lc,'WriteString',['SEQ ON,' num2str(n) ',' num2str(dat_L-2)],true);
    LCsetTRIG(lc,'ARM')
    
    pause(2.8);
    
    [x,y]= LCreadwf(lc,'C2');pause(0.1);
    
    t = reshape(x,dat_L,n);
    v = reshape(y,dat_L,n);
    save([Fname '.mat'],'t','v');
    agoff;
    
    clear x y v t
    
end

invoke(lc,'WriteString','SEQ OFF',true);