%Chris Adams, SRI 2019
%Generate a matrix of waveforms:
%Dimensions: [wobble amount x element num x time]

%% What wobbles do you want to test?
wobRange = 6*pi;%(1:0.5:6)*pi;

%Amplitude
amp = 1;%0.23;

%Not prealloc. Slow and don't care
wavMatr = [];
swWavMatr = [];
%Central frequency of TXR
fc = 1.7e6;
%Sampling frequency
fs = 160E6;%100*fc;
%Time vector (100 cycles)
%In reality this will be 100000s of cycles...
t = 0:1/fs:3.21E-3;%0:1/fs:20/fc;
%Number of elements in the 10-strip
nElem = 8;
for wobIdx=1:length(wobRange)
    %number of elements, wobble amount, fc, t
    wavMatr(wobIdx,:,:) = amp.*continuousPhaseModulation(nElem,wobRange(wobIdx),fc,t);
    %Grab the pwm equiv at same time (for each element)
%     for elIdx=1:nElem
%         swWavMatr(wobIdx,elIdx,:) = UARP_AHRPWM_no_fig(t, wavMatr(wobIdx,elIdx,:), fs, 1);
%         %Display each waveform against the switched waveform
%         figure(100);
%         plot(t,squeeze(wavMatr(wobIdx,elIdx,:)));
%         hold on;
%         stairs(t,squeeze(swWavMatr(wobIdx,elIdx,:)));
%         hold off;
%         %Generate a title
%         ttl = ['CPM of ' num2str(wobRange(wobIdx)/pi) 'pi. El. ' num2str(elIdx)];
%         title(ttl);
%         disp('Press enter for next');
%         pause
%         
%         
%     end
    %imagesc(squeeze(wavMatr(wobIdx,:,:)))
    
end



