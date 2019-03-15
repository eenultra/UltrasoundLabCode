% This program is used to control the timing between the laser flashlamp
% firing and the Q-switch openning. Thus controlling the output energy.

% Default timing between Flash lamps and Q-switch is set to 225 us,
% although this isn't max energy. That is at 180us.

%Timing is varied between the Quantum Composers TTL box

% Ch A  - Flash lamp fire
% Ch B  - Qswitch fire
% Ch C  - Other trigger (typically for Ultrasound, i.e. HIFU transducer)
% Ch D  - DAQ trigger 

%James McLaughlan
%University of Leeds
%Jun 2016

%fprintf(QC,':PULSE1:DELAY 0E-6');
%fprintf(QC,':PULSE2:DELAY 225E-6'); % default values

%soundSpeed   - sound speed of medium (typically 1480 m/s) 
%outputLevel  - % of laser output, needs input file  'QswitchCal.csv'
%txdFreq      - freq of sync transducer (i.e. HIFU txd, 1.1 or 3.3 MHz)   
%txdFocalLen, - focal length of sync transducer (i.e. HIFU 63mm)
%txdCycle     - sync between when laser/ultrasound arrives at target, and
%were in the output cycle.
%txdPN        - sync with the pos or negavtive cycle of ultrasound

%e.g. QCcontrol(1480, 60, 3.3E6, 63E-3, 4,'N')

%QCcontrol(1480, 100, 0, 0, 0,'N') if only doing PA without other transmit
%TXD use these values

function QCcontrol(soundSpeed, outputLevel, txdFreq, txdFocalLen, txdCycle, txdPN)

global QC 

try
    tFile = csvread('QswitchCalv2.csv');
catch
    disp('Flash lamp, Q-switch calibration file not found');
    return
end

id = find(tFile(:,2) >= outputLevel - (outputLevel*0.01) & tFile(:,2) <= outputLevel + (outputLevel*0.01),1,'first');
 
newDelay = 200E-6 + tFile(id,1)*1E-6; %corrected from 225um to account for drop in output

fprintf(QC,':PULSE1:DELAY 0E-6');
fprintf(QC,[':PULSE2:DELAY ' num2str(newDelay)]); % sets timing of Qswitch based on outputLevel (%)

% to correct the timing so that the laser pulse arrives at a specific point
% in the US cycle.

if txdPN == 'P'  
    delayCycle = 0.57 * txdCycle/txdFreq;
elseif txdPN == 'N'
    delayCycle = 0.66 * txdCycle/txdFreq;
else
    disp('Not valid Value for txdPN')
    return
end
    
txdDelay = newDelay - (txdFocalLen/soundSpeed) - delayCycle;% + 0.15E-6;

fprintf(QC,[':PULSE3:DELAY ' num2str(txdDelay)]);
fprintf(QC,':PULSE4:DELAY 0E-6'); %should be set on scope to be trigger of Ch3
