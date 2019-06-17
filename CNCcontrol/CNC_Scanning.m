global CNC

% Set default parameters
CNC.SoftwareLimits.X.Values = [0 0];
CNC.SoftwareLimits.X.Enabled = false;
CNC.SoftwareLimits.Y.Values = [0 0];
CNC.SoftwareLimits.Y.Enabled = false;
CNC.SoftwareLimits.Z.Values = [0 0];
CNC.SoftwareLimits.Z.Enabled = false;
CNC.SoftwareLimits.R.Values = [-180 180]; 
CNC.SoftwareLimits.R.Enabled = true;

disp('Initializing...')

CNC_OpenConnection('COM4');
CNC_EnableDrives();


disp('Remove clamps from vertical (Z) axis. Then press any key to continue.')
pause

CNC_Home();
CNC_Status();


CNC_CurrentPosition()
CNC_CommandedPosition()

% Ask user to fit transducer

disp('Fit Transducer. When done, press any key to continue.')
pause


%% 

% For 2D scanning(Ex: XZ plane) - Set Yscan to position wanted, 
% YMax and YMin to 0 and Yres to 1; 
% The system will move through the X and Z range while sitting in the first Y
% position

clearvars X* Y* Z*

Xscan = 0;    Xn= Xscan; %Inital/Central x Position
Yscan = 40;   Yn = Yscan; %Inital/Central y Position
Zscan = 0;    Zn = Zscan; %Inital/Central z Position

Xres = 10;  %x resolution
Yres = 5;  %y resolution
Zres = 10;  %z resolution

XMin = 0; %x start
XMax = 50; %x end

YMin = -10; %y start
YMax = 10; %y end

ZMin = 0; %z start
ZMax = 0; %z end

%Creating the scan vectors for iteration

Xscan = (XMin:Xres:XMax) + Xscan;
Yscan = (YMin:Yres:YMax) + Yscan;
Zscan = (ZMin:Zres:ZMax) + Zscan;

a=[];
%% 

for i=1:length(Xscan)
    
    Xn = Xscan(i);
    disp(['X=' num2str(Xn) 'mm, scan-line ' num2str(i) ' of ' num2str(length(Xscan))]);
    CNC_MovePositionLinear(Xn,Yn,Zn,0,true);
     
    for j=1:length(Yscan)
        
        Yn = Yscan(j);
        disp(['Y=' num2str(Yn) 'mm']); 
        CNC_MovePositionLinear(Xn,Yn,Zn,0,true)

        for k=1:length(Zscan)
         
            Zn = Zscan(k);
            disp(['Z=' num2str(Zn) 'mm']); 
            CNC_MovePositionLinear(Xn,Yn,Zn,0,true)
            v=getWaveform('192.168.1.5', 1);
            a=[a v];
        end
    end 
end
max(a)

%% Park CNC system


CNC_MovePosition(0,0,100,0,true);

disp('Apply clamps to vertical (Z) axis. Then press any key to continue.')
pause
 
CNC_DisableDrives();

CNC_CloseConnection();



