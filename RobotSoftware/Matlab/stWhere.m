%by James McLaughlan
%University of Leeds
%May 2017

function POS = stWhere

global ST

stCommand('WHERE')

L1 = fscanf(ST, '%s');
L2 = fscanf(ST, '%s');
L3 = fscanf(ST, '%s'); % Position
L4 = fscanf(ST, '%s'); % Previous Position
L5 = fscanf(ST, '%s');
L6 = fscanf(ST, '%s');

id1 = find(L3 == '.');% find '.' as only 1sgf after it before end of value
id2 = find(L4 == '.');

xCur = str2double(L3(1:id1(1)+1));
xPre = str2double(L4(5:id2(1)+1));

yCur = str2double(L3(id1(1)+2:id1(2)+1));
yPre = str2double(L4(id2(1)+2:id2(2)+1));

zCur = str2double(L3(id1(2)+2:id1(3)+1));
zPre = str2double(L4(id2(2)+2:id2(3)+1));

pCur = str2double(L3(id1(3)+2:id1(4)+1));
pPre = str2double(L4(id2(3)+2:id2(4)+1));

rCur = str2double(L3(id1(4)+2:id1(5)+1));
rPre = str2double(L4(id2(4)+2:id2(5)+1));

POS = [xCur yCur zCur pCur rCur];

