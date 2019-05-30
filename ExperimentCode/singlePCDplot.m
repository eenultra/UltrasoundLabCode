%% basic code to batch plot a single quasi-CW HIFU data saved during hifuPlot code

% University of Leeds
% James McLaughlan
% April 2019

ln  = 2;
fnt = 18;

fname = 'R3_Off'; 

plot(t-1,bbF,'color',[127.5 0 0]/255,'LineWidth',ln);
axis([-1 16 -1 50]);
xlabel('Time (s)','FontSize',fnt);
ylabel('Inertial Cavitation Dose (dB)','FontSize',fnt);
set(gca,'LineWidth',ln,'FontSize',fnt);
     
saveas(gcf,fname,'tiffn');saveas(gcf,fname,'epsc');    


%phOn 'color',[33 64 154]/255 
%nrOff 'color',[127.5 0 0]/255
%nrOn 'color',[8 135 67]/255