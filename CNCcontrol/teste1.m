global CNC

% Set default parameters
CNC.SoftwareLimits.X.Values = [-20 80];
CNC.SoftwareLimits.X.Enabled = false;
CNC.SoftwareLimits.Y.Values = [0 0];
CNC.SoftwareLimits.Y.Enabled = false; 
CNC.SoftwareLimits.Z.Values = [0 0];
CNC.SoftwareLimits.Z.Enabled = false;
CNC.SoftwareLimits.R.Values = [-180 180];
CNC.SoftwareLimits.R.Enabled = true;

%%
CNC_Start();
    
%%

clearvars X* Y* Z*

Xscan = 80;    Xn= Xscan; %Inital/Central x Position
Yscan = 12;   Yn = Yscan; %Inital/Central y Position
Zscan = -100;    Zn = Zscan; %Inital/Central z Position

Xres = 2;  %x resolution
Yres = 2;  %y resolution
Zres = 2;  %z resolution

XMin = -2; %x range start
XMax = 6; %x range end

YMin = -9; %y range start
YMax = 8; %y range end

ZMin = -8; %z range start
ZMax = 8; %z range end

%For scanning in YZ plane Xmax and Xmin to 0, Xres to 1 and Xscan
%to the position wanted in the X axis;

%Creating the scan vectors for iteration

Xscan = (XMin:Xres:XMax) + Xscan;
Yscan = (YMin:Yres:YMax) + Yscan;
Zscan = (ZMin:Zres:ZMax) + Zscan;

%Iteration limit
it=0;
maxit=3;

%%
        
clear a b c data;
control = true;
while control
    
        % Y axis scan
        
        for j=1:length(Yscan)
            Yn = Yscan(j);
            CNC_MovePositionLinear(Xn,Yn,Zn,0,true);
            disp(['Y=' num2str(Yn) 'mm']); 
            data=getWaveform('192.168.1.5', 2);
            a(:,j)=max(data)
        end 
        
        %Find new best Y position using the data gathered;
        [Ybest YBestIndex]=max(a);
        Yn=Yscan(YBestIndex);
        %Half resolution for a finer search around new optimum Y;
        Yres=(Yres/2);                   
        YMin=(YMin/2);
        YMax=(YMax/2);
        %Recalculate new Yscan around best position found;
        Yscan = (YMin:Yres:YMax) + Yn;  
        
        
        
        % Z axis scan
        
        for k=1:length(Zscan)
            Zn = Zscan(k);
            CNC_MovePositionLinear(Xn,Yn,Zn,0,true);
            disp(['Z=' num2str(Zn) 'mm']); 
            data=getWaveform('192.168.1.5', 2);
            b(:,k)=max(data)
        end
        
        %Find new best Z position using the data gathered;
        [Zbest ZBestIndex]=max(b);
        Zn=Zscan(ZBestIndex);
        %Half resolution for a finer search around new optimum Z;
        Zres=(Zres/2);                   
        ZMin=(ZMin/2);
        ZMax=(ZMax/2);
        %Recalculate new Zscan around best position found;
        Zscan = (ZMin:Zres:ZMax) + Zn;  
        
        
        
        % X axis scan
        
        for i=1:length(Xscan)
            Xn = Xscan(i);
          
%             if Xn < CNC.SoftwareLimits.X.Values(1)
%                 Xn = CNC.SoftwareLimits.X.Values(1);    
%             end
%             
%             if Xn > CNC.SoftwareLimits.X.Values(2)
%                 Xn = CNC.SoftwareLimits.X.Values(2);
%             end
            
            
            CNC_MovePositionLinear(Xn,Yn,Zn,0,true);
            disp(['X=' num2str(Xn) 'mm']); 
            data = getWaveform('192.168.1.5', 2);
            c(:,i) = max(data)
        end 
        
        %Find new best X position using the data gathered;   
        [Xbest XBestIndex]=max(c);
        Xn=Xscan(XBestIndex);
        %Half resolution for a finer search around new optimum X;
        Xres=(Xres/2);                   
        XMin=(XMin/2);
        XMax=(XMax/2);
        %Recalculate new Xscan around best position found;
        Xscan = (XMin:Xres:XMax) + Xn;  
       
        Xscan(Xscan>94)=94;
        Xscan(Xscan<55)=55;    
        CNC_CurrentPosition();   
        %Check for exit conditions, clear waveform data variables;
        
        it=it+1;
        clear a b c data;
        
        if it == maxit 
            control = false;
        end
        %Other stop cirteria can be resolution too small, or small
        %differnce between two optimum values
end

CNC_MovePositionLinear(Xn,Yn,Zn,0,true)
%%
CNC_Park();

