
Off   = [0,0,0];
onOff = [3.3005, 3.4542, 3.5671, 3.3554];
offOn = [3.3845, 3.6259, 3.3945];

X = [mean(Off),mean(onOff),mean(offOn)];
sX = [std(Off),std(onOff),std(offOn)];

%%
bar(X,'FaceColor',[0 0.5 0],'EdgeColor',[0 0 0],'LineWidth',1.5);hold on
errorbar(1:3,X,sX,'Marker','.','LineStyle','none','Color',[0 0 0],'LineWidth',1.5,'MarkerSize',5);%hold on
hold off
ylabel('Lesion Area (mm^2)','fontsize',18);
set(gca,'LineWidth',2,'FontSize',18);
set(gca,'XTickLabel',{'No Laser','Off-7.5s','On-7.5s'},'XTickLabelRotation',45);
set(gca,'Ytick',0:0.5:5);
xlim([0.5 3.5])

name = 'LaserOnOff';

saveas(gcf,name,'tiffn');saveas(gcf,[name '.fig']);saveas(gcf,[name '.eps'],'epsc');

%%

bWidth = 0.4;

bar(0.5,X(1),bWidth,'FaceColor',[0 0 0.4],'EdgeColor',[0 0 0],'LineWidth',1);hold on
bar(1,X(2),bWidth,'FaceColor',[0 0.4 0],'EdgeColor',[0 0 0],'LineWidth',1);
bar(1.5,X(3),bWidth,'FaceColor',[0.4 0 0],'EdgeColor',[0 0 0],'LineWidth',1);

errorbar(0.5,X(1),sX(1),'Marker','.','LineStyle','none','Color',[0 0 0],'LineWidth',1,'MarkerSize',5);
errorbar(1,X(2),sX(2),'Marker','.','LineStyle','none','Color',[0 0 0],'LineWidth',1,'MarkerSize',5);
errorbar(1.5,X(3),sX(3),'Marker','.','LineStyle','none','Color',[0 0 0],'LineWidth',1,'MarkerSize',5);
hold off

ylabel('Viability (%)','fontsize',18);
set(gca,'LineWidth',2,'FontSize',18);
%set(gca,'XTickLabel',{'A549+Laser','A549+NP','A549+NP+Laser'},'XTickLabelRotation',45);
legend('A549+Laser','A549+NP','A549+NP+Laser');
set(gca,'Ytick',0:25:100);set(gca,'Xtick',[]);
xlim([0.2 1.8])
title('Photothermal Therapy')


name = 'A549ToxPW';

%saveas(gcf,name,'tiffn');saveas(gcf,[name '.fig']);saveas(gcf,[name '.eps'],'epsc');