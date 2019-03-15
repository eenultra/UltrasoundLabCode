function AGloadARB(AG,NM,T)

agoff

fileID = fopen([NM '.csv']);%fopen('Pre_cf5_MHz_5us_tk0.25.csv');
WF     = fscanf(fileID, '%c');
Frq    = round(1/T);

fprintf(AG,['DATA VOLATILE, ' WF]);    % uploads the waveform to ARB via RS232

fprintf(AG,'FUNC:USER VOLATILE')
%fprintf(AG,'FUNC:SIN')
fprintf(AG,'BURSt:STATe ON')
fprintf(AG,['BURS:NCYC ' num2str(1)])
agSetVolt(10/1E3);
agSetFreq(Frq);

fclose(fileID);