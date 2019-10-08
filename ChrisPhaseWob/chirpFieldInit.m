function simargs = parFieldInit(res,wob)

    %Init fieldII if it hasn't already

    try
        field_info;
    catch ME
        field_init(1);
    end



    %% Init and trans params
    %field_end;

    % Area def
    z_start = 15e-2-30e-3;
    %z_start = 20e-3;
    z_stop = 15e-2+30e-3;
    %z_stop = -0e-3;

    %z_stop = 100e-3;
    x_start = -15e-3;
    % x_start = -60e-3;
    x_stop = 15e-3;

    %Define speeds and stuf
    
    fmin=1.7e6;
    fmax=1.7e6; 
    fcent = 1.7e6;
    
    fs=160e6;
    
    B=0;
    c=1540;%  Speed of sound [m/s]
    T=100/fmin;
    window ='none';
    t = 0:1/fs:T-(1/fs);

    lambda=c/fmax;%  Wavelength [m]
    height=110e-3;%  Height of element [m]
    %height=11e-2;%  JAMES

    N_elements=10;%  Number of elements
    %width=lambda;%  Width of element [m]
    %width = 1e-2; %JAMES
    kerf=0.2e-3;%  Distance between transducer elements [m] DMUA
    %width = (2*lambda)-kerf; %DMUA
    width = 11.7e-3;
    %kerf = width/8;%JAMES
    Rconvex = 15e-2; % DMUA
    %Rconvex = 1e6; %basically flat
    %Rconvex = 11e-2; % James

    no_sub_x=5;%  Number of sub-divisions in x-direction of elements.
    no_sub_y=5;%  Number of sub-divisions in y-direction of elements.
    %Focus to the middle of the window
    fx = x_start + ((x_stop-x_start)/2);
    fz = z_start + abs(z_start - z_stop)/2;
    fx = 0e-3;
    fz = 1e6; %Effectibvely no delays
    focus=[fx 0 fz];  %  Initial electronic focus
    angle = rad2deg(atan(focus(1)/abs(focus(3))))
    %  Define the transducer
    %Th = xdc_linear_array (N_elements, width, height, kerf, ...
    % no_sub_x, no_sub_y, focus);

    % clearvars -except c fx fz t B T fs fmax fmin ir N_elements  lambda z_stop x_stop z_start x_start width height Rconvex no_sub_x no_sub_y focus kerf

    %% Get wave forms based on field size
     impulse_response=sin(2*pi*fmin*(0:1/fs:2/fmin));
%     wavs = continuousPhaseModulation;

    clearvars d1 d2 B w
    %% Define grid 
    step = lambda*4/res;

    num_points_z = round(2*(z_stop - z_start)/step);  % Half wavelength mesh size
    num_points_x = round(2*(x_stop - x_start)/step);


    xpoints = linspace(x_start, x_stop, num_points_x)';
    ypoints = zeros((num_points_x * num_points_z), 1);
    zpoints = linspace(z_start, z_stop, num_points_z)';


    %%
    %clearvars -except t analog bipolar third third_fifth fs f T t
%     field_init;

    %% Setup params

    % Th = xdc_convex_array(N_elements, width,height,kerf,Rconvex,no_sub_x,no_sub_y,focus);
    Th = xdc_linear_array(N_elements, width,height,kerf,no_sub_x,no_sub_y,focus);
    %Add a lens
    totalWidth = (N_elements-1)*kerf;
    totalWidth = totalWidth + (N_elements*width);

    for ii=1:N_elements
        x=((0:(no_sub_x-1))-(no_sub_x-1)/2)/no_sub_x*width;
        x = x+(width/2);
        x = x+((ii-1)*(width+kerf));
        x = x-(totalWidth/2);

        zf = -Rconvex;

        y = ((0:(no_sub_y-1))-(no_sub_y-1)/2)/no_sub_y*height;

        [x,y] = meshgrid(x,y);

        basic_delay = sqrt(x.^2 +zf.^2 + y.^2)/c;
        delays(ii,:) = reshape(basic_delay',1,...
             no_sub_x*no_sub_y);
    end

    delays = delays-max(delays(:));


    delays = -1*delays;

%     figure(91);
%     imagesc(delays);
%     axis image;

    ele_delay(Th, (1:N_elements)', delays);
    %Change the default focus position
    %xdc_center_focus(Th,[0 0 Rconvex]);

    %JAMES
    %Th = xdc_linear_array(N_elements, width,height,kerf,no_sub_x,no_sub_y,focus);
    %
    %% Show what it looks like
%     figure(1);
%     % subplot(2,1,1);
%     show_xdc(Th);
    %%
    % clearvars width height Rconvex no_sub_x no_sub_y focus kerf
    %%  Set the impulse response of the xmit aperture (BR)
    xdc_impulse (Th, impulse_response);

%     excitations = repmat(analog',1,N_elements);
    excitations = continuousPhaseModulation(10,wob,fcent,t)';

    %%
    %Do analog first and keep it for reference
    % global simargs;

    simargs.Th = Th;
    simargs.N_elements = N_elements;
    simargs.excitations = excitations;
    simargs.xpoints = xpoints;
    simargs.ypoints = ypoints;
    simargs.zpoints = zpoints;
    simargs.fmin = fmin;
    simargs.excitations = excitations;
    %Generate a mesh grid
    [X Z] = meshgrid(simargs.xpoints, simargs.zpoints);
    simargs.points = [X(:), simargs.ypoints, Z(:)];
    ele_waveform(Th,(1:N_elements)',excitations');

end