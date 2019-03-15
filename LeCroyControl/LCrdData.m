% Data for the 5MHz ******9 number transducer @4MHz
% Xy = [25.0000    19.0000;...
%       50.0000    38.0000;...
%       100.0000   80.0000;...
%       150.0000   120.0000;...
%       200.0000  160.0000;...
%       250.0000  240.0000;...
%       ];
  
 % Data for the 2.25MHz *****39 number transducer @2MHz
% Xy =  [50.0000    55.0000;...
%       100.0000   110.0000;...
%       150.0000   165.0000;...
%       200.0000  230.0000;...
%       250.0000  280.0000]; 

 % Data for the 1MHz *****39 number transducer @1MHz

% Data for the 2.25 MHz transducer use a 100% Chirp
%X2      = [100 200 300 400 490];
%Xy      = zeros(5,2);  
%Xy(:,2) = X2;

        for j=1:3

            name = ['0p6-1p4MHz_Olympus_450mV_R' num2str(j) '_05Jun14'];

            %agSetFreq(1*1E6);
            N  = 100002;
            fs = 5E9;

            Xy = 0.6:0.1:1.4;%50:10:450;

            d1 = 1.92E-6;%4.0E-6;%2.40E-6; % delay setting for the voltage signal
            d2 = 15.20E-6;%19.0E-6;%31.0E-6; % delay setting for the pressure reading     

            P = zeros(N,length(Xy));
            V = zeros(N,length(Xy));

            for i=1:length(Xy)

                %agSetVolt(Xy(i)/1E3);
                agSetFreq(Xy(i)*1E6);
                
                lcclsw(lc);pause(0.1);

                LCsetTRDL(lc,d2);pause(0.1);
                LCsetTRIG(lc,'NORM');pause(1);LCsetTRIG(lc,'STOP');
                [x,y]= LCreadwf(lc,'C2');pause(0.1);
                LCsetTRDL(lc,d1);pause(0.1);
                LCsetTRIG(lc,'NORM');pause(1);LCsetTRIG(lc,'STOP');
                [t,v]= LCreadwf(lc,'C1');pause(0.1);

                P(:,i) = HydrophoneInverseFilter(y,fs,2); %0.2um hydrophone used.
                V(:,i) = v;

            end

            save([name '.mat'],'fs','P','V','x','t','d1','d2');

        end

agoff;


