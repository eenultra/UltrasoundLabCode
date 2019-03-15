function pos = Zmove(axis,val,type,verbose)

%Zmove;

%Moves the selected axis by the defined amount
%axis - the axis X,Y or Z
%dir  - the direction P for positive dir, N for negative dir
%val  - the distance to move in mm (this depends on type of displacement
%type - moving mode, A absolute displacement, R relative displacement
%Verbose - prints position info.

% eg. pos = Zmove('X','P',10,'R');
% eg. pos = Zmove('X',-10,'R');

%Creates a global pointer called ZO
%Not a true function as it has to pass the global variable

%James McLaughlan
%University of Leeds
%Oct 2013

%modified Dec 2013 to auto-detect dir based on sign of val.
%speed from system 4.5 mm/s

global ZO Zspd

if val > 0
    dir = 'P';
else
    dir = 'N';
end

fprintf(ZO, ['GoPosition ' axis ',O,' type ',' dir ',' num2str(abs(val))]);

if verbose == 1
disp(['Moving ' num2str(val) ' mm in ' axis ' axis...']);
end

idtest = fscanf(ZO);
if verbose == 1
disp(idtest);
end

pause((abs(val)/Zspd)+0.1);

idn   = fscanf(ZO);
if verbose == 1
disp(idn);
end

id1 = find(idn == ' ',1,'first');
id2 = find(idn == ',',1,'first');
pos = str2double(idn(id1+1:id2-1));

clear idn id1 id2