function fnSetVolt(volts)
%agSetVolt(volts)
%Sets Voltage amplitude of output

%James McLaughlan
%Unversity of Leeds,
%April 2021

global fgen

if volts >= 500E-3
    disp('WARNING OUTPUT LEVEL TOO HIGH!');
    fprintf(AG,'VOLT 0.01');
else
    fprintf(fgen,['VOLT ' num2str(volts)]);
end
