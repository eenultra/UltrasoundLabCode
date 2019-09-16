fid = fopen('C1GaN_1p1MHz_PWM20pc00000.txt','r'); % open for reading
txt = textscan(fid,'%s','delimiter', '\n'); txt = txt{1}; % read lines and unbox
fclose(fid);

tempDat = zeros(length(txt)-5,2); %data starts at line 6, just header infor before then.

for i=1:length(txt)-5
    tempDat(i,:) = str2double(strsplit(txt{i+5},','));    
end