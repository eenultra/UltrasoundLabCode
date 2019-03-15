%Level(1,1) = 2;
%Level(1,2) = 42;

% Data for the 5MHz ******9 number transducer @4MHz
Xy = [ 50.0000   38.0000;...
      100.0000   80.0000;...
      150.0000   120.0000;...     
      200.0000   160.0000;...
      250.0000   240.0000;...
      300.0000   310.0000;...
      350.0000   380.0000;...
      400.0000   450.0000;...
      ];
%{  
% Data for the 5MHz ******9 number transducer @4MHz
Xy = [25.0000    19.0000;...
      50.0000    38.0000;...
      100.0000   80.0000;...
      150.0000   120.0000;...
      200.0000  160.0000;...
      250.0000  240.0000;...
      ];
%}

% Data for the 5MHz ******9 number transducer using chirps
% Xy = [25.0000    32.0000;...
%       50.0000    62.0000;...
%       100.0000   130.0000;...
%       150.0000   190.0000;...
%       200.0000  270.0000;...
%       250.0000  350.0000;...
%       ];

 % Data for the 2.25MHz *****39 number transducer @2MHz
% Xy =  [50.0000    55.0000;...
%       100.0000   110.0000;...
%       150.0000   165.0000;...
%       200.0000  230.0000;...
%       250.0000  280.0000]; 

 % Data for the 1MHz *****39 number transducer @1MHz

% Data for the 2.25 MHz transducer use a 100% Chirp
% X2      = [100 200 300 400 490];
% Xy      = zeros(5,2);  
% Xy(:,2) = X2;

si    = size(Xy);

dat_L = 50002;%50002;%25002;%12502 
n     = 200;

t = zeros(dat_L,n);
v = zeros(dat_L,n);

file = 'ARB_NoUS_R1_12Apr13';%JefUV%NoMB

desc.info   = 'Jefinity microbubbles scatter, 1 mg/ml';
desc.flow   = 'scatter'; %20ml/h';%'resonance freq exp in tank 125.02 ml vol';%'flow rate 1 ml / h';%
desc.Bconc  = '1:10000';%'concentration ~ 1:12500, i.e. 0.02 ml in 125ml ~ 2E6';%;'1E6 bubbles / ml';%

invoke(lc,'WriteString',['SEQ ON,' num2str(n) ',' num2str(dat_L-2)],true);
LCsetTRIG(lc,'STOP');lcclsw(lc)

for i=1:si(1)%si(1):-1:1%
   
    j=i;

    %agSetFreq(4*1E6);
    agSetVolt(Xy(j,2)/1E3);

    Fname = ['Freq_4MHz_P' num2str(Xy(j,1),'%0.0f') 'kPa_' file];
    %disp(['Freq = AWG Level = ' num2str(Xy(j,2)) 'mV'])
    disp(['4 MHz - ' num2str(Xy(j,2)) ' mV']);
    
%      input('Ready?');
%      disp(' ');
%      pause(15);   
    
    agon
    
    %vdiv=LCmaxVDIV(lc,'C1');
    %pause(0.1);
        
    %invoke(lc,'WriteString',['SEQ ON,' num2str(n) ',' num2str(dat_L-2)],true);
    LCsetTRIG(lc,'ARM');
    
    pause(3);
    
    [x,y]= LCreadwf(lc,'C2');pause(0.1); % CHECK INPUT CHANNEL
    %desc_w
    t = reshape(x,dat_L,n);
    v = reshape(y,dat_L,n);
    save([Fname '.mat'],'t','v','desc');
    agoff;
    
    clear x y v t
%     lcclsw(lc)
end

invoke(lc,'WriteString','SEQ OFF',true);agSetVolt(25/1E3);
LCsetTRIG(lc,'NORM');