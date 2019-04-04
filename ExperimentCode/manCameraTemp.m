%%
close all
clear all

imageNames  = dir(fullfile('20180904*.mat')); % change to start date of interest
imageNames  = {imageNames.name}';
cal         = 25; % pixel diameter of the circle placed in the image
tempRange   = [15 45]; %Temp range for plot
refLocation = 620; % show referance image at end of heating (0.5 Hz aqu)
time        = linspace(0,((60*5)+20)*2,((60*5)+20)*2); %total aqu time (5 min exposure, 10s before/after at every 0.5s)
tempOut     = zeros(640,length(imageNames));


for ii = 1:length(imageNames)
    disp(['Processing ' num2str(ii) ' of ' num2str(length(imageNames))]);
    disp(['File ' imageNames{ii}]);
    load(fullfile(imageNames{ii})); % load in mat file
    [pathstr,imName,ext] = fileparts(fullfile(imageNames{ii})); 
    tempDat = zeros(length(tData),1);
    figure(1);
    imagesc(tData(:,:,refLocation));hold on
    [x,y,z]=impixel;  % The coordinates that the user specifies for the centre location of the cell
    [cx,cy,c_mask]  = circle_plt(x,y,cal);
    [row,col]       = find(c_mask == 1);     
    col             = col - cal;                % correction, not clear why needed?
    
    for j=1:length(tData)                      % runs loop for each image aquired during exposure
    tempDat(j,1) = mean(mean(tData(row,col,j))); % averages this over the circle
    end
    figure(2);plot(time,tempDat);drawnow;
    save(['out_' imName '.mat'],'x','y','cal','tempDat','time');  
    tempOut(:,ii) = tempDat;  
end

output_matrix=[imageNames'; num2cell(tempOut)];     %Join cell arrays

save('temp_dat.mat','tempOut','time');
xlswrite('TempData.xls',output_matrix);

break
%% What follows is how I plot the data, not needed for processing.

X = xlsread('TempEg.xls');
%A2(std),B2(std),B4(std),C2(std),C4(std),WT(std)
time = linspace(0,640,640)/120; %total aqu time (5 min exposure, 10s before/after at every 0.5s)

%%

ln  = 2;
mkr = 10;
fnt = 16;
nSD  = 1;
% 

%{
1. darkred = [127.5 0 0]/255;
2. red = [237 28 36]/255;
3. orange = [241 140 34];
4. yellow = [255 222 23]; 
5. lightgreen = [173 209 54];
6. darkgreen = [8 135 67];
7. lightblue = [71 195 211];
8. darkblue = [33 64 154];
9. purple = [150 100 155]/255;
10. pink = [238 132 181];
%}

% plot(time,A2fit,'-.','color',[33 64 154]/255,'LineWidth',ln,'MarkerSize',mkr);hold on
% plot(time,B2fit,'color',[127.5 0 0]/255,'LineWidth',ln,'MarkerSize',mkr);
% plot(time,B4fit,'--','color',[8 135 67]/255,'LineWidth',ln,'MarkerSize',mkr);
% plot(time,C2fit,'color',[241 140 34]/255,'LineWidth',ln,'MarkerSize',mkr);
% plot(time,C4fit,':','color',[33 64 154]/255,'LineWidth',ln,'MarkerSize',mkr);
% plot(time,WTfit,'-','color',[71 195 211]/255,'LineWidth',ln,'MarkerSize',mkr);


plot(time,X(:,1),'color',[127.5 0 0]/255,'LineWidth',ln);hold on
plot(time,X(:,2),'color',[255 222 23]/255,'LineWidth',ln);
plot(time,X(:,3),'color',[8 135 67]/255,'LineWidth',ln);
plot(time,X(:,4),'color',[150 100 155]/255,'LineWidth',ln);
% plot(time,X(:,9),'color',[237 28 36]/255,'LineWidth',ln);
% plot(time,X(:,11),'color',[71 195 211]/255,'LineWidth',ln);


% errorbar(time,X(:,1),X(:,2)/sqrt(nSD),'+','color',[33 64 154]/255,'LineWidth',ln);
% errorbar(time,X(:,3),X(:,4)/sqrt(nSD),'x','color',[127.5 0 0]/255,'LineWidth',ln);
% errorbar(time,X(:,5),X(:,6)/sqrt(nSD),'o','color',[8 135 67]/255,'LineWidth',ln);
% errorbar(time,X(:,7),X(:,8)/sqrt(nSD),'s','color',[241 140 34]/255,'LineWidth',ln);
% errorbar(time,X(:,9),X(:,10)/sqrt(nSD),'^','color',[33 64 154]/255,'LineWidth',ln);
% errorbar(time,X(:,11),X(:,12)/sqrt(nSD),'d','color',[71 195 211]/255,'LineWidth',ln);
hold off

xlabel('Time (min)','FontSize',fnt);ylabel('Temperature Rise (^{\circ}C)','FontSize',fnt);
axis([0 11 0 10]);
%legend('AuNP','CNT-LongCOOH','AuNP/CNT-LongCOOH','CNT-ShortCOOH','AuNP/CNT-ShortCOOH','Water','Location','northwest');
legend('Water','CS','GO','PV','Location','northwest')
set(gca,'Xtick',0:1:11,'Ytick',0:5:20);
set(gca,'FontSize',fnt,'LineWidth',ln);
saveas(gcf,'AveTempSc','epsc');saveas(gcf,'AveTempSc','png');


%%

Y     = [Tox(:,1) Tox(:,3)];
Y_plt = [Tox(1,1),Tox(1,3),Tox(2,1),Tox(2,3),Tox(3,1),Tox(3,3),Tox(4,1),Tox(4,3),Tox(5,1),Tox(5,3),Tox(6,1),Tox(6,3)];
STD   = [Tox(1,2),Tox(1,4),Tox(2,2),Tox(2,4),Tox(3,2),Tox(3,4),Tox(4,2),Tox(4,4),Tox(5,2),Tox(5,4),Tox(6,2),Tox(6,4)];

figure
hold on
bh = bar(Y,'EdgeColor',[0 0 0],'LineWidth',1.0);
set(bh(1),'FaceColor',[71 195 211]/255);
set(bh(2),'FaceColor',[127.5 0 0]/255);
axis([0.5 6.50 0 120]);
legend('No Laser','Laser','Location','northwest');
set(gca,'XTickLabel',{'A2','B2','B4','C2','C4','Water'});
ylabel('Cell Viability (%)','Fontsize',14);
xlabel('Type','Fontsize',14);
dif = 0.28;
xData =[0.86,0.86+dif,1.86,1.86+dif,2.86,2.86+dif,3.8571,3.86+dif,4.86,4.86+dif,5.86,5.86+dif];
errorbar(xData,Y_plt,STD,'k.','linewidth',1.5)

saveas(gcf,'NPcellTox','epsc');saveas(gcf,'NPcellTox','png');
