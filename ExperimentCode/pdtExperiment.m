%%

%Thorlabs Stage
LS3open;
disp('Check Thermal Camera is Connected');

nMin    = 14;      % number of mins of exposure
expTime = 60*nMin; % exposure time in s

%% Init IR camera
global IRInterface;
tBuff      = 10;  %s, time buffer for before/after exposure data
totalTime  = (tBuff*2 + expTime); % total temp aquisition time
rate       = 10;                 % aquire data every 10 seconds
totalSamples = totalTime/rate;    % number of temp frames


%%
fName = 'pdt_Test';
tData = zeros(480,640,totalSamples);

for j=1:totalSamples
   % grab image data
   RGB = IRInterface.get_palette();                  % grab palette image
   THM = (IRInterface.get_thermal()-1000)/10;        % grab thermal image, convereted to deg C
   tData(:,:,j) = THM;
   imagesc(THM);colormap('hot');colorbar;drawnow;
   tt = toc;
   pause(rate-tt);   
end

disp('Saving....');
save([fName '.mat'],'totalTime','rate','tBuff','tData');
        
