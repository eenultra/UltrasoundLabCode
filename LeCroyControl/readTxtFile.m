
type = 'Si';                         % pulser type
freq = '3p3';                         % HIFU frequency
PWM  = [40 60 100]; % PWM range used for study
Run  = 3;

fid1 = fopen(['C1' type '_' freq 'MHz_PWM' num2str(PWM(1)) 'pc0000' num2str(0) '.txt'],'r');
txt1 = textscan(fid1,'%s','delimiter', '\n'); txt1 = txt1{1}; % read lines and unbox
fclose(fid1);

datLength = length(txt1) - 5; % scans data length and removes header;
clear fid1 txt1

c1Data = zeros(datLength,length(PWM),Run);
c2Data = zeros(datLength,length(PWM),Run);

for p=1:Run
    disp(['Run ' num2str(p)]);
    for j=1:length(PWM)

        disp(['PWM ' num2str(PWM(j)) ' %']);
        fid1 = fopen(['C1' type '_' freq 'MHz_PWM' num2str(PWM(j)) 'pc0000' num2str(p-1) '.txt'],'r'); % open for reading
        fid2 = fopen(['C2' type '_' freq 'MHz_PWM' num2str(PWM(j)) 'pc0000' num2str(p-1) '.txt'],'r'); % open for reading
        txt1 = textscan(fid1,'%s','delimiter', '\n'); txt1 = txt1{1}; % read lines and unbox
        txt2 = textscan(fid2,'%s','delimiter', '\n'); txt2 = txt2{1}; % read lines and unbox
        fclose(fid1);fclose(fid2);

        c1Temp = zeros(datLength,2); %data starts at line 6, just header info before then.
        c2Temp = zeros(datLength,2); %data starts at line 6, just header info before then.

            for i=1:length(txt1)-5
                c1Temp(i,:) = str2double(strsplit(txt1{i+5},','));
                c2Temp(i,:) = str2double(strsplit(txt2{i+5},',')); 
            end
            
        c1Data(:,j,p) = c1Temp(:,2); % write C1 volt data to array;
        c2Data(:,j,p) = c2Temp(:,2); % write C2 volt data to array;
    
            if (p==1) && (j==1)
                Time = c1Temp(:,1); % get time info, only once in loop
            end
    
    end
end

save(['190906_Hydro_' type '_' freq 'MHz_dat.mat'],'c1Data','c2Data','Time','PWM','Run','freq');


