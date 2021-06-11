%% Reshape MSOT data, 5 locations

wavelength = 700:5:1150;
NR1       = X1;
PBS2       = X2;

nr_meanData =  zeros(length(wavelength),1);
nr_stdData  =  zeros(length(wavelength),1);
pbs_meanData =  zeros(length(wavelength),1);
pbs_stdData  =  zeros(length(wavelength),1);

for i=1:length(wavelength)
    
    datStart = 5*(i-1) + 1;
    datEnd   = (5*i);
    
    nr_meanData(i,1) =  mean(NR1(datStart:datEnd,1));
    nr_stdData(i,1)  =  std(NR1(datStart:datEnd,1));
    
    pbs_meanData(i,1) =  mean(PBS2(datStart:datEnd,1));
    pbs_stdData(i,1)  =  std(PBS2(datStart:datEnd,1));
    
end

errorbar(wavelength,nr_meanData,nr_stdData,'r');hold on
errorbar(wavelength,pbs_meanData,pbs_stdData,'b'); hold off
xlabel('Wavelength (nm)');ylabel('Mean Pixel Intensity (MSOT a.u.)');
axis([700 1150 0 350]);
title('D_20, old1064nr');
legend('NRs','PBS');
