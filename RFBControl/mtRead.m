% read weight Mettler-Toledo scales, used from RFB measurements
% Chris Adams and James McLaughlan
% University of Leeds
% Jan 2019

function w = mtRead 

global MT

fopen(MT);
pause(0.1);
balanceString=fscanf(MT);
pause(0.1);
fclose(MT);

cols = strsplit(balanceString, ' ');
w    = str2double(cols{3});
      




