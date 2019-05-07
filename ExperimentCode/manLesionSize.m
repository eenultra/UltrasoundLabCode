% manual code for calculating lesion volume size from an image taken with
% the Dinolite cameras.

% note - due to the poor contrast between phantom and lesion, i have found
% manual identification of the lesion is best. However if you find a way
% for automating it that would be great!

% University of Leeds
% James McLaughlan
% April 2019

close all
clear all

imageNames  = dir(fullfile('*frames161.jpg')); 
% as part of the hifuPlot code, I get the first frame (in this case 161) after HIFU exposure 
% saved to a single different location to help with batch processing. This
% just reads in all of them.

imageNames  = {imageNames.name}'; % just saves file names
D = 1/200; %px/mm %%% This calibration needs to be correct for each experiment. %%%
% for each setup, I image a known target (e.g. metal ball) to get correct
% calibration for focus setting on camera.

for ii = 1:length(imageNames) % this code loops through all images in dir
    disp(['Processing ' num2str(ii) ' of ' num2str(length(imageNames))]);
    img = imread(fullfile(imageNames{ii})); % reads in current file
    [pathstr,imName,ext] = fileparts(fullfile(imageNames{ii})); 
    imshow(img); % displays image to user
    hold on
    [x,y,z]=impixel; 
    % this command allows the user to click on the image and draw around
    % the lesion, press enter when you have finished.
    % if no lesion is present, just hit enter

    if isempty(x) == 1
        A = 0; % sets area = 0 if no lesion was present
    else
        x = [x;x(1)]; % creates a complete loop
        y = [y;y(1)]; % creates a complete loop
        plot(x, y,'g','LineWidth', 3);drawnow % shows what you have drawn
        hold off
        total = trapz(x,y); % calculates pix area
        A = abs(total*(D*D)); % converts to area typically mm2 depends what units D is
    end
    
    out(ii,1) = cellstr(imName); % saves data in xls sheet
    out(ii,2) = cellstr(num2str(max(A))); % saves data in xls sheet
    % I have found that due to inconstancies in how imageNames is found, I find the best way to collate the data
    % is by manually arranging repeat datasets. I'm sure this could be
    % automoated but I find this the easiest way. 
    
    clear x y z % clears values before processing the next image
end

save('lesion_dat.mat','out','A'); % saves data to a mat file
xlswrite('lesionData',out); % also saves to a .xls file (see comment above)

return
%% Everything beyond this point is not needed and is only here for me to keep consistant how I plot/display the data
% feel free to use the code, but it is not part of the image processing

%pnp = [0.91 1.19 1.43 1.69 1.92 2.13 2.34 2.53 2.71];
% 20 40 60 80 100 120 140 160 180 200 220
pnp = [0.20 0.62 0.91 1.19 1.43 1.69 1.92 2.13 2.34 2.53 2.71];

ln  = 2;
mkr = 10;
fnt = 16;
nSD  = 1;

p1  = polyfit(pnp',mean(nrOff,2),6); nrOFFfit = polyval(p1,pnp);
p2  = polyfit(pnp',mean(nrOn,2),6);  nrONfit  = polyval(p2,pnp);
p3  = polyfit(pnp',mean(phOn,2),6);  phONfit  = polyval(p3,pnp);

%{
plot(pnp,f,'b',pnp,fl,'r','LineWidth',ln);hold on
legend('Laser OFF','Laser ON','Location','NorthWest');
errorbar(pnp,mean(Lon,2),std(Lon,[],2),'rx','LineWidth',ln,'MarkerSize',mkr);
errorbar(pnp,mean(Loff,2),std(Loff,[],2),'bx','LineWidth',ln,'MarkerSize',mkr);
set(gca,'FontSize',fnt,'LineWidth',ln);
axis([0.75 3.00 -0.25 7.5]);
xlabel('Peak Negative Pressure (MPa)','FontSize',fnt);
ylabel('Thermal Lesion Area (mm^2)','FontSize',fnt);
hold off
%}

plot(pnp,phONfit,'-.','color',[33 64 154]/255,'LineWidth',ln,'MarkerSize',mkr);hold on
plot(pnp,nrOFFfit,'color',[127.5 0 0]/255,'LineWidth',ln,'MarkerSize',mkr);
plot(pnp,nrONfit,'--','color',[8 135 67]/255,'LineWidth',ln,'MarkerSize',mkr);

errorbar(pnp,mean(phOn,2),std(phOn,[],2)/sqrt(nSD),'+','color',[33 64 154]/255,'LineWidth',ln);
errorbar(pnp,mean(nrOff,2),std(nrOff,[],2)/sqrt(nSD),'x','color',[127.5 0 0]/255,'LineWidth',ln);
errorbar(pnp,mean(nrOn,2),std(nrOn,[],2)/sqrt(nSD),'o','color',[8 135 67]/255,'LineWidth',ln);hold off

xlabel('Peak Negative Pressure (MPa)','FontSize',fnt);ylabel('Thermal Lesion Area (mm^2)','FontSize',fnt);
axis([0 3.0 -0.5 11]);
legend('+HIFU/+LS/-NR','+HIFU/-LS/+NR','+HIFU/+LS/+NR','Location','northwest');
set(gca,'Xtick',0:0.5:3,'Ytick',0:1:12);
set(gca,'FontSize',fnt,'LineWidth',ln);
saveas(gcf,'totalArea','epsc');saveas(gcf,'totalArea','png');

%%


%%
pnp = [0.20 0.62 0.91 1.19 1.43 1.69 1.92 2.13 2.34 2.53 2.71];

ln  = 2;
mkr = 10;
fnt = 16;
nSD  = 1;

p1  = polyfit(pnp',mean(nrOff,2),6); nrOFFfit = polyval(p1,pnp);
p2  = polyfit(pnp',mean(nrOn,2),6);  nrONfit  = polyval(p2,pnp);
p3  = polyfit(pnp',mean(phOn,2),6);  phONfit  = polyval(p3,pnp);

plot(pnp,phONfit/1E3,'-.','color',[33 64 154]/255,'LineWidth',ln,'MarkerSize',mkr);hold on
plot(pnp,nrOFFfit/1E3,'color',[127.5 0 0]/255,'LineWidth',ln,'MarkerSize',mkr);
plot(pnp,nrONfit/1E3,'--','color',[8 135 67]/255,'LineWidth',ln,'MarkerSize',mkr);

errorbar(pnp,mean(phOn,2)/1E3,(std(phOn,[],2)/sqrt(nSD))/1E3,'+','color',[33 64 154]/255,'LineWidth',ln);
errorbar(pnp,mean(nrOff,2)/1E3,(std(nrOff,[],2)/sqrt(nSD))/1E3,'x','color',[127.5 0 0]/255,'LineWidth',ln);
errorbar(pnp,mean(nrOn,2)/1E3,(std(nrOn,[],2)/sqrt(nSD))/1E3,'o','color',[8 135 67]/255,'LineWidth',ln);hold off

legend('+HIFU/+LS/-NR','+HIFU/-LS/+NR','+HIFU/+LS/+NR','Location','northwest');
set(gca,'FontSize',fnt,'LineWidth',ln);
axis([0 3.0 -0.5 4]);
set(gca,'Xtick',0:0.5:3,'Ytick',0:0.5:4);
xlabel('Peak Negative Pressure (MPa)','FontSize',fnt);
ylabel('Total Inertial Cavitation Dose (10^3 au)','FontSize',fnt);

saveas(gcf,'totalBB','epsc');saveas(gcf,'totalBB','png');


