function cleanCOM(SerialPort)

%cleanCOM(SerialPort)
%
% Serial={1,2, etc.}

SerialPort=num2str(SerialPort);

out=instrfind;
[dum2 dum1]=size(out);
if dum1 ~= 0
    for ii=1:dum1
        if strcmp(out(ii).Type,'serial') == 1
            if strcmp(out(ii).Port,['COM',SerialPort]) == 1
                disp(['Warning: Found instrument on COM',SerialPort,'. Deleting...']);
                fclose(out(ii));
                delete(out(ii));
                clear out(ii);
            end
        end
    end
end

out = instrfind('RsrcName', ['ASRL',SerialPort,'::INSTR']);

if ~isempty(out)
    disp(['Warning: Found VISA instrument object using COM',SerialPort,'. Deleting...']);
    fclose(out);
    delete(out);
end