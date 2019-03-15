% Cal the laser outout using q-switch timing and energy meter

clearvars -except lc ZO QC AG RT EM

wav  = 838;        % wavelength range to cal over
nAv  = 10;         % no of in Energy measure average
Rrng = 0:0.1:85;   % scan range, increased delay between flash lamp and Q-switch in us
Eval = zeros(nAv,1);
Emn  = zeros(length(Rrng),1);
Est  = zeros(length(Rrng),1);
    
EnergyW    = zeros(length(Rrng),length(wav));
EnergyErr  = zeros(length(Rrng),length(wav));
EnergyF    = zeros(length(Rrng),length(wav));

theDate = '20170522';

for k=1:length(wav)

    input(['Please select wavelength: ' num2str(wav(k)) 'nm']);

    EMwav(wav(k)); %sets the wavelength on sensor

    name = [theDate '_QScal_' num2str(wav(k)) 'nm'];

    for i=1:length(Rrng)

       fprintf(QC,[':PULSE2:DELAY ' num2str(200E-6 + Rrng(i)*1E-6)]); % default values
       disp(['DELAY ' num2str(200 + Rrng(i)) ' us']); % changed from 225us
       
       EMrange
       for n=1:nAv        
           tmp = 0;
           while tmp == 0
           EMtemp    = EMread;
               if EMtemp < 100
                   tmp = 1;
               end
           end
           Eval(n,1) = EMtemp;    
       end

       Emn(i,1) = mean(Eval);
       Est(i,1) = std(Eval,[],1);

    end

    figure(2);
    errorbar(Rrng,Emn*1E3,Est*1E3,'xb');
    xlabel('Delay ({\mu}s)');
    ylabel('Energy (mJ)');
    hold on

    p = polyfit(Rrng,Emn',4);Efit = polyval(p,Rrng);

    plot(Rrng,Efit*1E3,'b');
    hold off

   EnergyW(:,k)   =  Emn;
   EnergyErr(:,k) =  Est;
   EnergyF(:,k)   =  Efit;
   
   save([name '.mat'],'Rrng','Efit','Emn','Est');
end

if length(wav) > 1
name2 = [theDate '_QScal_' num2str(wav(1)) '-' num2str(wav(end)) 'nm'];   
save([name2 '.mat'],'Rrng','wav','EnergyW','EnergyErr','EnergyF');
end

figure(3);  
imagesc(wav,Rrng,EnergyW*1E3);colorbar
