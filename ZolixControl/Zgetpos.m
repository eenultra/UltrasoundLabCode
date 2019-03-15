function [x y z] = Zgetpos(verbose)

%Zgetpos

%Queries the current position of each of the stages
%output each position to the workspace

%Creates a global pointer called ZO
%Not a true function as it has to pass the global variable

%e.g. [x y z] = Zgetpos;

%James McLaughlan
%University of Leeds
%Oct 2013

global ZO

fprintf(ZO, 'Position? X');pause(0.1);  % changed 16th Oct 2014 due to problems with system, should be X
idx = fscanf(ZO);
ix = find(idx == ',');x = str2double(idx(ix(1)+1:ix(2)-1));

fprintf(ZO, 'Position? Y');pause(0.1);
idy = fscanf(ZO);
iy = find(idy == ',');y = str2double(idy(iy(1)+1:iy(2)-1));

fprintf(ZO, 'Position? Z');pause(0.1);
idz = fscanf(ZO);
iz = find(idz == ',');z = str2double(idz(iz(1)+1:iz(2)-1));

if verbose == 1
disp(['X= ' num2str(x) ' mm, Y= ' num2str(y) ' mm, Z= ' num2str(z) ' mm']);
end

clear idx idy idz ix iy iz