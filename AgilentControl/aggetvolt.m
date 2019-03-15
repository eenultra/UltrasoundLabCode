function volts=agsetvolt;
%volts=aggetvolt
%Gets Voltage amplitude of output

%Robin Cleveland
%Boston University
%June 2008

global AG

fprintf(AG,['SOUR:VOLT?']);
rettext=fscanf(AG);
%bidx=findstr(rettext,' ');
bidx=1:length(rettext);
volts=str2num(rettext(bidx(1):bidx(end)));
