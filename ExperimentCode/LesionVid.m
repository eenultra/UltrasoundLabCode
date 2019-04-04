
VidDIR = 'U:\Ultrasound\Postdoc\James McLaughlan\Lab Computers\DAQ\20170524-NRHIFU\HIFU\Videos'; % location of stored videos and frames
rootCD = 'U:\Ultrasound\Postdoc\James McLaughlan\Lab Computers\DAQ\20170524-NRHIFU\HIFU\RAW';    %location of files

SI   = ls('20170524*.mat');
si   = size(SI);
fnt  = 16;
ln   = 2;

resX = 1/200;%/225; % mm/pix
resY = 1/200;%/225; % mm/pix

X =  linspace(-resX*(1280/2),resX*(1280/2),1280);%1280;
Y =  linspace(-resY*(1024/2),resY*(1024/2),1024);%1024;

for j=45:si(1)
    
    disp(['Processing ' num2str(j) ' of ' num2str(si(1))]);
    id   = find(SI(j,:) == '.',1,'last');
    Fname = SI(j,1:id-1);
    load([Fname '.mat']);
    h1 = figure;
    set(h1,'position',[100 50 1280 1024]);
    mkdir(VidDIR,Fname);
      for i=1:170
        rgbImage = whitebalance(frames(:,:,:,i));
        %imagesc(X,Y,frames(:,:,:,i)/256);
        imagesc(X,Y,rgbImage);
        set(gca,'FontSize',fnt,'LineWidth',ln);
        xlabel('Axial Distance (mm)','FontSize',fnt);
        ylabel('Radial Distance (mm)','FontSize',fnt);
        set(gca,'Xtick',-2.5:0.5:2.5,'Ytick',-2:0.5:2);
            if (i > 10) && (i <= 160)
                text(-2.8,-2.4,'HIFU On','FontSize',16);
            else
                text(-2.8,-2.4,'HIFU Off','FontSize',16);
            end
        %output image filename (index with zero-padded 4-digit integers)
        filename = sprintf('frames%03d.jpg',i);
        %export the image
        
        if i==161
            export_fig(h1, [VidDIR '\' Fname '_' filename],'-q95','-transparent');
        end
        export_fig(h1, [VidDIR '\' Fname '\' filename],'-q95','-transparent');
      end

    cd([VidDIR '\' Fname '\']);
    imageNames  = dir(fullfile('*.jpg'));
    imageNames  = {imageNames.name}';
    outputVideo = VideoWriter(fullfile(VidDIR,['vid_' Fname '.avi'])); %#ok<TNMLP>
    outputVideo.FrameRate = 10;
    outputVideo.Quality   = 100;
    open(outputVideo)
    
    for ii = 1:length(imageNames)
        img = imread(fullfile(imageNames{ii}));
        writeVideo(outputVideo,img)
    end
    
    close(outputVideo);
    close(gcf);
    cd(rootCD);
end


%%
fnt = 18;
ln  = 5;

rgbImage = whitebalance(fmP2phOn);
imagesc(X,Y,rgbImage);
        
set(gca,'FontSize',fnt,'LineWidth',ln);       
%xlabel('Axial Distance (mm)','FontSize',fnt);     
%ylabel('Radial Distance (mm)','FontSize',fnt);
set(gca,'Xtick',-2.5:0.5:2.5,'Ytick',-2:0.5:2);
set(gca,'XTickLabel',[],'YTickLabel',[]);
%set(gca,'Xtick',[],'Ytick',[]);
saveas(gcf,'fmP2phOn','epsc');

%load('20170524_R1_PH_839nm_Lon_40PC_160mV');fmP2phOn = frames(:,:,:,161);

