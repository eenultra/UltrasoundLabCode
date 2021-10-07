%%%%%%% Hydrophone Inverse Filter %%%%%%
%
% BandPassFilter 0.5MHz - 20MHz (-120dB)
%
% SN1284 1.0mm needle hydrophone (hydrophone_type = 1) %OLD DO NOT USE IN
% THE BIN
% SN1574 0.2mm needle hydrophone (hydrophone_type = 2)
%         40um needle hydrophone (hydrophone_type = 3)
% SN2711 1.0mm needle hydrophone (hydrophone_type = 4) %added by chris
% 23/05/2018
%
% Measured at T = 22-26 Deg C
% DC Supply Voltage = 28V
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Updates
% 0.2 mm needle tip calibrated in Nov 2020 (1-20 MHz only, beyond that is previous cal)
% 1.0 mm needle tip calibrated in Nov 2020
% See Ultrasound\Laboratory\Equipment\Precision Acoustics Hydrophone for
% details

% Ex:   >> x_pres = HydrophoneInverseFilter(C2Nchirp10_500kPa00001(:,2),1e9,1);
function [x_pres] = HydrophoneInverseFilter(x,sampling_frequency,hydrophone_type)

x = x(:)';
duration = length(x)/sampling_frequency;

if (hydrophone_type == 1)
%%%%%% Sensitivity of SN1284 (mV/MPa), 1.0 mm needle
hydrophone = [ 0 1433 1046 1007 1035 1031 1066 1079 1087 1101 1083 1084 ...
    1036 984 889 807 709 599 513 434 374]; % 
hydrophonemin = 270;
frequency_step_size = 1e6;
max_frequency = 20e6;

elseif (hydrophone_type == 2)
%%%%%% Sensitivity of SN1574 (mV/MPa),0.2 mm needle
hydrophone = [ 0 22 32 38 38 35 41 39 33 32 31 31 33 39 40 37 36 35 36 36 33 ...
    43 43 43 44 45 46 46 45 46 45 ];  
hydrophonemin = 30;
frequency_step_size = 1e6;
max_frequency = 30e6;

elseif (hydrophone_type == 3)
%%%%%% Sensitivity of 40um (nV/Pa)
hydrophone = -[ 0 128 308 260 228 269 299 256 204 205 248 235 230 226 218 195 190 190 205 217 236 ...
    220 225 210 196 179 168 148 130 110 96 ];
hydrophonemin = 96;
frequency_step_size = 2e6;
max_frequency = 60e6;

elseif (hydrophone_type == 4)
%%%%%% Sensitivity of 40um (nV/Pa)
hydrophone = [0 1587 1169 1124 1111 1109 1123 1119 1114 1113 1086 1088 1040 ...
    982 889 785 690 574 490 400 337];
hydrophonemin = min(hydrophone(2:end));
frequency_step_size = 1e6;
max_frequency = 20e6;

else
warning('Luigi, which hydrophone are you using!!!')
end

freq_steps = 0:frequency_step_size:max_frequency;

%Added by chris. What if we're using a shitty silly scope?
%...and sampling frequency is too low for max_frequency
if(max_frequency > sampling_frequency)
    %Change max frequency to nearest whole 1MHz
    max_frequency = floor((sampling_frequency/2)/1e6)*1e6;
    %We need to trim hydrophone appropriatly, what's the index of that
    %frequency?
    [~,hydrophoneTrimIdx] = min(abs(max_frequency-freq_steps));
    hydrophone = hydrophone(1:hydrophoneTrimIdx);
    freq_steps = 0:frequency_step_size:max_frequency;
end

% Comments added by chris, but code not written by me. Sevan wrote it?

%Interpolate missing values based on the points we know
hydrophoneP = interp1(freq_steps,hydrophone,0:1/duration:max_frequency,'pchip');

%Not used so removing this line
% freq_stepsP = interp1(freq_steps,freq_steps,0:1/duration:max_frequency);
% Filtering -120dB

hydrophone_freq_response = hydrophonemin*1e6*ones(length(x),1)';    
hydrophone_freq_response(floor(0.5e6*duration):floor(max_frequency*duration)) = hydrophoneP(floor(0.5e6*duration):floor(max_frequency*duration));

hydrophone_freq_response(floor((sampling_frequency*duration)-(max_frequency*duration)):floor((sampling_frequency*duration)-(0.5e6*duration))) = ...
    fliplr(hydrophoneP(floor(0.5e6*duration):floor(max_frequency*duration)));

x_pres = (1e9) * real(ifft(fft(x)./hydrophone_freq_response))';