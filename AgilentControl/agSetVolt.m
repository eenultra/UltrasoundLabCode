function agSetVolt(volts)
%agSetVolt(volts)
%Sets Voltage amplitude of output

%Robin Cleveland
%Boston University
%May 2006

global AG

if volts >= 500E-3
    disp('WARNING OUTPUT LEVEL TOO HIGH!');
    fprintf(AG,'VOLT 0.01');
else
    fprintf(AG,['VOLT ' num2str(volts)]);
end
