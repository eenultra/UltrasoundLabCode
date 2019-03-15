%Zopen;
%Opens up Zolix XYZ system and send the initialisation command 'Hello',
%which returns OK, if correct.

%Error codes:
%E00 - No connection between MC600 and PC, please send 'Hello'
%E01 - Communication error, illegal command received or communication
%time-out.

%Creates a global pointer called ZO
%Not a true function as it has to pass the global variable

%James McLaughlan & David Cowell
%University of Leeds
%Oct 2013

%Edited Dec 2013 to increase functionality

global ZO initX initY initZ Zspd

COM = 'COM5';%When using Serial Hub %'COM1';

ZO = serial(COM,'BaudRate',19200,'Terminator','CR','DataBits',8,'StopBits',1);
fopen(ZO);

fprintf(ZO, 'Hello');
idn = fscanf(ZO);%disp(idn);

%%% Get's start position for each axis %%%
fprintf(ZO, 'Position? X');pause(0.1);
idx = fscanf(ZO);
ix = find(idx == ',');initX = str2double(idx(ix(1)+1:ix(2)-1));

fprintf(ZO, 'Position? Y');pause(0.1);
idy = fscanf(ZO);
iy = find(idy == ',');initY = str2double(idy(iy(1)+1:iy(2)-1));

fprintf(ZO, 'Position? Z');pause(0.1);
idz = fscanf(ZO);
iz = find(idz == ',');initZ = str2double(idz(iz(1)+1:iz(2)-1));

disp(['Initial Positions: X= ' num2str(initX) 'mm, Y= ' num2str(initY) 'mm, Z= ' num2str(initZ) 'mm']);

%%% Get's start position for each axis %%%

fprintf(ZO, 'SetSpeed? X')
idx = fscanf(ZO);
ix = find(idx == ',');spdX = str2double(idx(ix(1)+1:ix(2)-1));

fprintf(ZO, 'SetSpeed? Y')
idy = fscanf(ZO);
iy = find(idy == ',');spdY = str2double(idy(ix(1)+1:iy(2)-1));

fprintf(ZO, 'SetSpeed? Z')
idz = fscanf(ZO);
iz = find(idx == ',');spdZ = str2double(idz(iz(1)+1:iz(2)-1));

disp(['Running Speed: X= ' num2str(spdX) 'mm/s, Y= ' num2str(spdY) 'mm/s, Z= ' num2str(spdZ) 'mm/s']);

reply = input('Do you want to change speed? y/n: ', 's');
TF = strcmp(reply, 'y');
if TF == 1
    newSpd = input('Enter new running speed in mm/s: ', 's');
    fprintf(ZO, ['SetSpeed X,' newSpd])
    idtest = fscanf(ZO);
    fprintf(ZO, ['SetSpeed Y,' newSpd])
    idtest = fscanf(ZO);
    fprintf(ZO, ['SetSpeed Z,' newSpd])
    idtest = fscanf(ZO);

    fprintf(ZO, 'SetSpeed? X')
    idx = fscanf(ZO);
    ix = find(idx == ',');spdX = str2double(idx(ix(1)+1:ix(2)-1));

    fprintf(ZO, 'SetSpeed? Y')
    idy = fscanf(ZO);
    iy = find(idy == ',');spdY = str2double(idy(ix(1)+1:iy(2)-1));

    fprintf(ZO, 'SetSpeed? Z')
    idz = fscanf(ZO);
    iz = find(idx == ',');spdZ = str2double(idz(iz(1)+1:iz(2)-1));

    disp(['Running Speed: X= ' num2str(spdX) 'mm/s, Y= ' num2str(spdY) 'mm/s, Z= ' num2str(spdZ) 'mm/s']);
    
else
    disp('Values kept'); 
end

Zspd = spdX;


