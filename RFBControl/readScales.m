%Try to close the com port in case it is open
try
   fclose(instrfind);
end

%Set scales to auto publish over the USB serial connection

s = serial('COM13');
try
    fclose(s);
end
set(s,'BaudRate',9600);
fopen(s);

% out = fscanf(s);
% fclose(s)
% delete(s)
% clear s

%Clear all the values in buffer
while(s.BytesAvailable)
    fscanf(s);
end

%how long should I record for
tic;
measure = [];
t = [];
disp('Waiting for values');
while(1)
    %Wait until some bytes available
    while(s.BytesAvailable)
    
    
        %get the reading
        balanceString = fscanf(s)
        disp('Got stable value');

        cols = strsplit(balanceString, ' ');
        %if valud measure
        if(size(cols,2) > 2)
            measure = [measure;str2num(cols{3})];
            t = [t; toc];
        end
    end
    
    pause(0.5);
end

%Grab vals



disp('Finished measuring');

fclose(s);

figure; 

plot(t(1:end-1),measure(1:end));

%% Convert into flow rate
rate = diff(measure)./diff(t);

%Density
density = 1; %g/cm3
flow = rate/density; %ml/s

flow = flow*(60*60); %ml/hour

figure; 
plot(t(1:end-1), flow);
xlabel('Time [s]');
ylabel('Flow rate [ml/h]');