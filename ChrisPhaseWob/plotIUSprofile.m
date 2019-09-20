function plotIUSprofile(P,simargs)
% 
%     ref = max(P(:));
% 
%     Q = 20*log10(P./ref);
Q = P;
    
    xpoints = simargs.xpoints;
    zpoints = simargs.zpoints;
    
    pl = -6;
    pu = 0;

    imagesc(xpoints * 1000,  zpoints * 1000, Q);
    xlabel('Lateral Distance [mm]');
    ylabel('Ax. Dist. [mm]');
    grid off;
    axis image; caxis([pl pu]);
    colormap(jet(128));
    colorbar;

    % c = colorbar('Location', 'southoutside');
    % c.Label.String = 'Power [dB]';
    % c.Label.Interpreter = 'latex';
    % c.Label.FontUnits = 'points';
    % c.Label.FontSize = 10;
    % caxis([pl pu]);
    % 
    fig = gcf; 
    fig.PaperUnits = 'inches';
    fig.PaperSize = [3.5 1.5];
    fig.PaperPosition = [0 0 3.5 1.5];

    set(findall(gcf,'-property','FontUnits'),'FontUnits','points');
    set(findall(gcf,'-property','FontSize'),'FontSize',10);
    set(findall(fig,'-property','Interpreter'),'Interpreter','latex');
    
end